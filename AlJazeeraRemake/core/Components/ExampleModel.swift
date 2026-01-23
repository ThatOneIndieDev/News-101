//
//  ExampleModel.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 14/01/2026.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsArticleViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading news...")
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        viewModel.refreshNews()
                    }
                } else if !viewModel.hasArticles {
                    EmptyStateView()
                } else {
                    ArticleListView(articles: viewModel.filteredArticles)
                }
            }
            .navigationTitle("News")
            .searchable(text: $viewModel.searchText, prompt: "Search news") // SO NO NEED FOR EXTERNAL SEARCH BAR FUNCTIONALITY
            .refreshable {
                viewModel.refreshNews()
            }
        }
    }
}

// MARK: - Subviews
struct ArticleListView: View {
    let articles: [Article]
    
    var body: some View {
        List(articles) { article in
            ArticleRowView(article: article)
        }
    }
}

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Simple AsyncImage
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(8)
            
            // Article Content
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                HStack {
                    Text(article.source.name)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(formatDate(article.publishedAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// Helper function to format date
private func formatDate(_ dateString: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
    return dateString
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry") {
                retry()
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "newspaper")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No articles available")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NewsView()
}
