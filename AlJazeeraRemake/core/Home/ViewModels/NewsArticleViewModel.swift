//
//  NewsArticleViewModel.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 20/01/2026.
//
import Foundation
import SwiftUI
import Combine


class NewsArticleViewModel: ObservableObject{
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let newsService = NewsFetchService()
    private var cancellables = Set<AnyCancellable>()
    

    
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
}
    
    

