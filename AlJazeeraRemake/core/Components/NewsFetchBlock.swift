//
//  NewsFetchBlock.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

/*
 
 EVERYTHING IS BLURRED HERE BECAUSE WE HAVE IMPLEMENTED THE NAVIGATION VIEW INSIDE A TAB VIEW IN THE MAIN SCREEN
 
 
 */

import SwiftUI

struct NewsFetchBlock: View {
    
    @StateObject private var vm = NewsArticleViewModel()
    @State private var animate = false
    let showLiveUpdates: Bool
    
    init(showLiveUpdates: Bool = true) {
        self.showLiveUpdates = showLiveUpdates
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if showLiveUpdates {
                liveButton
            }
            
            // Display articles in a list with navigation
            ForEach(vm.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    ArticleCard(article: article)
                        .padding(.horizontal, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NewsFetchBlock()
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Hero Image
                AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Metadata (author, date, source)
                    HStack(spacing: 8) {
                        if let author = article.author {
                            Text(author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if !article.publishedAt.isEmpty {
                            Text("•")
                                .foregroundStyle(.secondary)
                            Text(article.publishedAt)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if let source = article.author {
                        Text(source)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    // Description
                    if let description = article.description {
                        Text(description)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    
                    // Full Content
                    if let content = article.content {
                        Text(content)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                    }
                    
                    // Read more button (if URL available)
                    if !article.url.isEmpty {
                        Link(destination: URL(string: article.url)!) {
                            HStack {
                                Text("Read Full Article")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right.circle.fill")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Article Card Component
struct ArticleCard: View {
    let article: Article
    
    var body: some View {
        VStack(spacing: 0) {
            // Image at the top - full width rounded rectangle
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)
            
            // Timeline content below image
            VStack(spacing: 0) {
                // Top Headline Section
                HStack(alignment: .center, spacing: 8) {
                    // Circle indicator
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.white.opacity(0.9))
                            .frame(width: 15, height: 15)
                    }
                    .frame(width: 15, alignment: .center)
                    
                    // Article Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Top Headline")
                            .foregroundStyle(Color.white.opacity(0.6))
                            .font(.caption)
                        
                        Text(article.title)
                            .foregroundStyle(Color.white.opacity(0.9))
                            .font(.headline)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 12)
                
                // Connector line
                HStack(alignment: .top, spacing: 8) {
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 2, height: 30)
                    }
                    .frame(width: 15, alignment: .center)
                    
                    Spacer()
                }
                
                // Breaking Story Section
                HStack(alignment: .top, spacing: 8) {
                    // Circle indicator
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 15, height: 15)
                    }
                    .frame(width: 15, alignment: .center)
                    
                    // Article Description
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Breaking Story")
                            .foregroundStyle(Color.white.opacity(0.6))
                            .font(.caption)
                        
                        Text(article.description ?? "No description available")
                            .foregroundStyle(Color.white.opacity(0.9))
                            .font(.subheadline)
                            .lineLimit(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 8)
        }
        .background(Color.black.opacity(0.1))
        .cornerRadius(12)
    }
}

extension NewsFetchBlock {
    
    private var liveButton: some View {
        HStack(spacing: 8) {
            Circle()
                .stroke(.red, lineWidth: 2)
                .frame(width: 20)
                .overlay(
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(Color.red)
                        .opacity(animate ? 0.2 : 1.0)
                        .scaleEffect(animate ? 0.8 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                            value: animate
                        )
                        .onAppear {
                            animate = true
                        }
                )
            Text("Live Updates")
                .bold(true)
                .foregroundStyle(Color.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
}
