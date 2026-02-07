//
//  UserPreferencesService.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct UserPreferences {
    let followedArticleIDs: [String]
    let selectedTopicIDs: [String]
}

final class UserPreferencesService {
    private let db = Firestore.firestore()
    
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    func load() async throws -> UserPreferences? {
        guard let uid = currentUserID else { return nil }
        let snapshot = try await db.collection("users").document(uid).collection("meta").document("preferences").getDocument()
        guard let data = snapshot.data() else { return UserPreferences(followedArticleIDs: [], selectedTopicIDs: []) }
        let followed = data["followedArticleIDs"] as? [String] ?? []
        let topics = data["selectedTopicIDs"] as? [String] ?? []
        return UserPreferences(followedArticleIDs: followed, selectedTopicIDs: topics)
    }
    
    func saveFollowedArticles(_ ids: [String]) async throws {
        guard let uid = currentUserID else { return }
        try await db.collection("users").document(uid)
            .collection("meta").document("preferences")
            .setData(["followedArticleIDs": ids], merge: true)
    }
    
    func saveSelectedTopics(_ ids: [String]) async throws {
        guard let uid = currentUserID else { return }
        try await db.collection("users").document(uid)
            .collection("meta").document("preferences")
            .setData(["selectedTopicIDs": ids], merge: true)
    }
}

