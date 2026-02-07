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
    
    @ObservedObject var vm: NewsArticleViewModel
    @State private var animate = false
    let showLiveUpdates: Bool
    let selectedCategory: SelectedCategory
    
    init(vm: NewsArticleViewModel, showLiveUpdates: Bool = true, selectedCategory: SelectedCategory = .latest) {
        self.vm = vm
        self.showLiveUpdates = showLiveUpdates
        self.selectedCategory = selectedCategory
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if showLiveUpdates {
                liveButton
            }
            
            // Display articles in a list with navigation
            ForEach(displayedArticles) { article in
                NavigationLink(destination: ArticleDetailView(article: article, vm: vm)) {
                    ArticleCard(article: article)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
    
    private var displayedArticles: [Article] {
        switch selectedCategory {
        case .latest:
            return vm.articles
        case .following:
            return vm.followedArticles
        }
    }
}

#Preview {
    NewsFetchBlock(vm: NewsArticleViewModel())
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: Article
    @ObservedObject var vm: NewsArticleViewModel
    
    private var cleanedContent: String? {
        guard let content = article.content, !content.isEmpty else { return nil }
        let pattern = #"\\s*\\[\\+\\d+\\s*chars\\]\\s*$"#
        return content.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 16) {
                    // Hero Image (edge-to-edge, height-limited)
                    AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: proxy.size.width, height: 300)
                    .clipped()
                    
                    // Content
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(article.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // Metadata (author, date)
                        HStack(spacing: 8) {
                            if let author = article.author {
                                Text(author)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            
                            if !article.publishedAt.isEmpty {
                                Text("•")
                                    .foregroundStyle(.secondary)
                                Text(article.publishedAt)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
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
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        // Full Content
                        if let content = cleanedContent {
                            Text(content)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .lineSpacing(4)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        FollowButton(isFollowed: vm.isFollowed(article)) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                vm.toggleFollow(article)
                            }
                        }
                        
                        // Read more button (if URL available)
                        if let url = URL(string: article.url) {
                            Link("Read Full Article", destination: url)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .frame(width: proxy.size.width, alignment: .leading)
                }
            }
            .frame(width: proxy.size.width, alignment: .leading)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FollowButton: View {
    let isFollowed: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isFollowed ? "checkmark" : "plus")
                Text(isFollowed ? "Following" : "Follow Story")
            }
            .font(.headline)
            .foregroundStyle(isFollowed ? Color.black : Color.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule().fill(isFollowed ? Color.white : Color.white.opacity(0.12))
            )
            .overlay(
                Capsule().stroke(Color.white.opacity(isFollowed ? 0.2 : 0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
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
        .padding(.horizontal, 8)
        .frame(maxWidth: 700, alignment: .center)
        .frame(maxWidth: .infinity)
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

// Helper function to format date
private func formatDate(_ dateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: dateString) else {
        // Fallback: try without fractional seconds
        isoFormatter.formatOptions = [.withInternetDateTime]
        guard let date = isoFormatter.date(from: dateString) else {
            return dateString
        }
        return formatDateToString(date)
    }
    
    return formatDateToString(date)
}

private func formatDateToString(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: date, relativeTo: Date())
}
