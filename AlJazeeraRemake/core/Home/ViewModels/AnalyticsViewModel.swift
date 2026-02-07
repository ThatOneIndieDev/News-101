//
//  AnalyticsViewModel.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import Foundation
import Combine

struct AnalyticsSummary: Identifiable, Hashable {
    let id: String
    let title: String
    let sourceName: String
    let summaryWords: [String]
    let hasPrediction: Bool
    let predictionSeries: [Double]
}

final class AnalyticsViewModel: ObservableObject {
    @Published private(set) var summaries: [AnalyticsSummary] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let stopWords: Set<String> = [
        "the", "a", "an", "and", "or", "but", "if", "to", "of", "in", "on", "for",
        "with", "at", "by", "from", "up", "about", "into", "over", "after", "before",
        "under", "again", "further", "then", "once", "is", "are", "was", "were", "be",
        "been", "being", "as", "it", "its", "this", "that", "these", "those", "their",
        "they", "them", "he", "she", "his", "her", "we", "our", "you", "your"
    ]
    
    init(newsVM: NewsArticleViewModel) {
        newsVM.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.summaries = articles.map { article in
                    let title = article.title
                    let words = self?.summarize(title) ?? []
                    let canPredict = self?.looksPredictive(title: title, description: article.description) ?? false
                    return AnalyticsSummary(
                        id: article.id,
                        title: title,
                        sourceName: article.source.name,
                        summaryWords: words,
                        hasPrediction: canPredict,
                        predictionSeries: canPredict ? (self?.makeSeries(from: title) ?? []) : []
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func summarize(_ text: String) -> [String] {
        let tokens = text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty && !stopWords.contains($0) }
        
        let limited = Array(tokens.prefix(3))
        if limited.isEmpty {
            return Array(text.split(separator: " ").prefix(4)).map { String($0) }
        }
        
        return limited.map { $0.capitalized }
    }
    
    private func looksPredictive(title: String, description: String?) -> Bool {
        let text = "\(title) \(description ?? "")".lowercased()
        let triggers = [
            "forecast", "predict", "prediction", "expected", "outlook", "projected",
            "estimate", "could", "likely", "set to", "will", "trend", "rise", "fall"
        ]
        return triggers.contains { text.contains($0) }
    }
    
    private func makeSeries(from seedText: String) -> [Double] {
        let seed = seedText.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        var value = max(1, seed % 97)
        var series: [Double] = []
        
        for _ in 0..<7 {
            value = (value * 37 + 17) % 100
            series.append(Double(value) / 100.0)
        }
        return series
    }
}
