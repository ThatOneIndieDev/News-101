//
//  NewsArticleViewModel.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 20/01/2026.
//
import Foundation
import SwiftUI
import Combine
import FirebaseAuth


class NewsArticleViewModel: ObservableObject{
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published private(set) var followedIDs: Set<String> = []
    
    private let newsService = NewsFetchService()
    private var cancellables = Set<AnyCancellable>()
    private let preferencesService = UserPreferencesService()
    private var authHandle: AuthStateDidChangeListenerHandle?
    

    
    var filteredArticles : [Article]{
        if searchText.isEmpty{
            return articles
        }else {
            return articles.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.description?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    init() {
        setupSubscriptions()
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            Task {
                if Auth.auth().currentUser == nil {
                    await self?.resetFollowed()
                } else {
                    await self?.loadFollowed()
                }
            }
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupSubscriptions(){
        newsService.$articles
            .sink {[weak self] articles in
                self?.articles = articles
            }
            .store(in: &cancellables)
        
        newsService.$isLoading
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)
        
        newsService.$errorMessage
            .sink { [weak self] errorMessage in
                self?.errorMessage = errorMessage
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func refreshNews() {
        newsService.refresh()
    }
    
    func loadNews() {
        newsService.getNews()
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Helper Methods
    func getArticle(at index: Int) -> Article? {
        guard index >= 0 && index < filteredArticles.count else { return nil }
        return filteredArticles[index]
    }
    
    var hasArticles: Bool {
        !articles.isEmpty
    }
    
    var articlesCount: Int {
        filteredArticles.count
    }
    
    func isFollowed(_ article: Article) -> Bool {
        followedIDs.contains(article.id)
    }
    
    func toggleFollow(_ article: Article) {
        if followedIDs.contains(article.id) {
            followedIDs.remove(article.id)
        } else {
            followedIDs.insert(article.id)
        }
        Task { await saveFollowed() }
    }
    
    var followedArticles: [Article] {
        articles.filter { followedIDs.contains($0.id) }
    }
    
    @MainActor
    private func loadFollowed() async {
        do {
            if let prefs = try await preferencesService.load() {
                followedIDs = Set(prefs.followedArticleIDs)
            } else {
                followedIDs = []
            }
        } catch {
            // Silently fail for now
        }
    }
    
    @MainActor
    private func resetFollowed() async {
        followedIDs = []
    }
    
    private func saveFollowed() async {
        do {
            try await preferencesService.saveFollowedArticles(Array(followedIDs))
        } catch {
            // Silently fail for now
        }
    }
}
    
    
