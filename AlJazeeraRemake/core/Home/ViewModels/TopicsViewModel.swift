//
//  TopicsViewModel.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import FirebaseAuth
import Combine

struct Topic: Identifiable, Hashable {
    let id: String
    let name: String
}

final class TopicsViewModel: ObservableObject {
    @Published private(set) var allTopics: [Topic] = [
        Topic(id: "World", name: "World"),
        Topic(id: "Politics", name: "Politics"),
        Topic(id: "Business", name: "Business"),
        Topic(id: "Markets", name: "Markets"),
        Topic(id: "Technology", name: "Technology"),
        Topic(id: "Science", name: "Science"),
        Topic(id: "Climate", name: "Climate"),
        Topic(id: "Health", name: "Health"),
        Topic(id: "Culture", name: "Culture"),
        Topic(id: "Opinion", name: "Opinion"),
        Topic(id: "Sports", name: "Sports"),
        Topic(id: "Travel", name: "Travel"),
        Topic(id: "Education", name: "Education"),
        Topic(id: "Justice", name: "Justice"),
        Topic(id: "Security", name: "Security"),
        Topic(id: "Energy", name: "Energy")
    ]
    
    @Published private var selectedIDs: Set<String> = []
    
    private let preferencesService = UserPreferencesService()
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task {
                if user == nil {
                    await self?.reset()
                } else {
                    await self?.loadSelectedTopics()
                }
            }
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    private let topicKeywords: [String: [String]] = [
        "World": ["global", "international", "world", "united nations", "summit", "diplomacy"],
        "Politics": ["election", "parliament", "president", "government", "policy", "vote", "minister"],
        "Business": ["business", "company", "ceo", "corporate", "earnings", "revenue", "merger"],
        "Markets": ["stocks", "shares", "markets", "index", "trading", "dow", "nasdaq"],
        "Technology": ["tech", "ai", "software", "hardware", "startup", "cyber", "device"],
        "Science": ["research", "science", "study", "scientist", "space", "physics", "biology"],
        "Climate": ["climate", "carbon", "emissions", "warming", "weather", "extreme", "sustainability"],
        "Health": ["health", "medical", "hospital", "disease", "virus", "vaccine", "mental"],
        "Culture": ["culture", "art", "music", "film", "festival", "books", "heritage"],
        "Opinion": ["opinion", "editorial", "column", "commentary", "analysis"],
        "Sports": ["sport", "football", "soccer", "basketball", "tennis", "cricket", "olympics"],
        "Travel": ["travel", "tourism", "flight", "airline", "hotel", "destination"],
        "Education": ["education", "school", "university", "students", "learning", "teachers"],
        "Justice": ["court", "trial", "judge", "justice", "law", "legal"],
        "Security": ["security", "defense", "military", "attack", "police", "conflict"],
        "Energy": ["energy", "oil", "gas", "renewable", "power", "electricity"]
    ]
    
    var selectedTopics: [Topic] {
        allTopics.filter { selectedIDs.contains($0.id) }
    }
    
    func isSelected(_ topic: Topic) -> Bool {
        selectedIDs.contains(topic.id)
    }
    
    func toggle(_ topic: Topic) {
        if selectedIDs.contains(topic.id) {
            selectedIDs.remove(topic.id)
        } else {
            selectedIDs.insert(topic.id)
        }
        Task { await saveSelectedTopics() }
    }
    
    func topics(for article: Article) -> [Topic] {
        let text = "\(article.title) \(article.description ?? "")".lowercased()
        return allTopics.filter { topic in
            let keywords = topicKeywords[topic.id] ?? []
            return keywords.contains { text.contains($0) }
        }
    }
    
    func matchesSelectedTopics(_ article: Article) -> Bool {
        let matched = topics(for: article).map(\.id)
        return matched.contains { selectedIDs.contains($0) }
    }
    
    func selectedArticles(from articles: [Article]) -> [Article] {
        articles.filter { matchesSelectedTopics($0) }
    }
    
    @MainActor
    func loadSelectedTopics() async {
        do {
            if let prefs = try await preferencesService.load() {
                selectedIDs = Set(prefs.selectedTopicIDs)
            } else {
                selectedIDs = []
            }
        } catch {
            // Silently fail for now
        }
    }
    
    @MainActor
    func reset() async {
        selectedIDs = []
    }
    
    private func saveSelectedTopics() async {
        do {
            try await preferencesService.saveSelectedTopics(Array(selectedIDs))
        } catch {
            // Silently fail for now
        }
    }
}
