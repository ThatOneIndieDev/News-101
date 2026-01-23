//
//  NewsFetchService.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

import Foundation
import Combine

class NewsFetchService: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getNews()
    }
    
    private func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["NewsAPIKey"] as? String
        }
        return nil
    }
    
    func getNews() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API key not found"
            return
        }
        
        // Build URL with API key as query parameter
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=\(apiKey)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        let request = URLRequest(url: url)
        
        isLoading = true
        errorMessage = nil
        
        NetworkingManager.download(url: request)
            .decode(type: NewsModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch news: \(error.localizedDescription)"
                    print("Error fetching news: \(error)")
                }
            } receiveValue: { [weak self] newsModel in
                self?.articles = newsModel.articles
            }
            .store(in: &cancellables)
    }
    
    func refresh() {
        getNews()
    }
}
