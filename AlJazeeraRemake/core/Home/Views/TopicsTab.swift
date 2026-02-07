//
//  TopicsTab.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI

struct TopicsTab: View {
    @ObservedObject var authVM: AuthViewModel
    @ObservedObject var newsVM: NewsArticleViewModel
    @StateObject private var vm = TopicsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        
                        Text("All Topics")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                        
                        FlowLayout(spacing: 8, lineSpacing: 8) {
                            ForEach(vm.allTopics) { topic in
                                TopicCapsule(
                                    title: topic.name,
                                    isSelected: vm.isSelected(topic)
                                ) {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        vm.toggle(topic)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                        
                        Text("Your Topics")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                        
                        if vm.selectedTopics.isEmpty {
                            Text("Choose topics above to personalize your feed.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.bottom, 8)
                        } else {
                            FlowLayout(spacing: 8, lineSpacing: 8) {
                                ForEach(vm.selectedTopics) { topic in
                                    TopicCapsule(
                                        title: topic.name,
                                        isSelected: true
                                    ) {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            vm.toggle(topic)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if !vm.selectedTopics.isEmpty {
                            Divider()
                                .background(Color.white.opacity(0.2))
                            
                            Text("Articles for you")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(vm.selectedArticles(from: newsVM.articles)) { article in
                                        NavigationLink(destination: ArticleDetailView(article: article, vm: newsVM)) {
                                            TopicArticleCard(
                                                article: article,
                                                tags: vm.topics(for: article)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Topics")
            .task {
                if authVM.isAuthenticated {
                    await vm.loadSelectedTopics()
                }
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pick what you care about")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            
            Text("Tap to add a topic. Your selection will be saved to your account later.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

private struct TopicCapsule: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isBouncing = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isBouncing = true
                action()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isBouncing = false
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .font(.caption.weight(.semibold))
                
                Image(systemName: isSelected ? "checkmark" : "plus")
                    .font(.caption.weight(.bold))
            }
            .foregroundStyle(isSelected ? Color.black : Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.white : Color.white.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(isSelected ? 0.2 : 0.35), lineWidth: 1)
            )
            .scaleEffect(isBouncing ? 1.06 : 1.0)
            .offset(y: isBouncing ? -3 : 0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TopicsTab(authVM: AuthViewModel(), newsVM: NewsArticleViewModel())
        .preferredColorScheme(.dark)
}

private struct TopicArticleCard: View {
    let article: Article
    let tags: [Topic]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 220, height: 130)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(article.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .frame(width: 220, alignment: .leading)
            
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(tags.prefix(3)) { topic in
                            Text(topic.name)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Capsule())
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct FlowLayout: Layout {
    let spacing: CGFloat
    let lineSpacing: CGFloat
    
    init(spacing: CGFloat = 8, lineSpacing: CGFloat = 8) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? UIScreen.main.bounds.width
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth + size.width > maxWidth {
                totalHeight += rowHeight + lineSpacing
                totalWidth = max(totalWidth, rowWidth)
                rowWidth = size.width + spacing
                rowHeight = size.height
            } else {
                rowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
        }
        
        totalHeight += rowHeight
        totalWidth = max(totalWidth, rowWidth)
        
        return CGSize(width: maxWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + lineSpacing
                rowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(width: size.width, height: size.height)
            )
            
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
