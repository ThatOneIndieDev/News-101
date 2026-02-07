//
//  MainScreen.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: ChosenCategory = .news
    @StateObject private var newsVM = NewsArticleViewModel()
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area based on selected tab
            TabView(selection: $selectedTab) {
                NewsTab(newsVM: newsVM)
                    .tag(ChosenCategory.news)
                
                AnalyticsTab(newsVM: newsVM)
                    .tag(ChosenCategory.analytics)
                
                TopicsTab(authVM: authVM, newsVM: newsVM)
                    .tag(ChosenCategory.topics)
                
                ProfileTab(authVM: authVM)
                    .tag(ChosenCategory.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Prevents default tab bar
            
            // Custom footer
            Footer(selectedTab: $selectedTab)
        }
    }
}

// MARK: - News Tab
struct NewsTab: View {
    @ObservedObject var newsVM: NewsArticleViewModel
    @State private var selectedCategory: SelectedCategory = .latest
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AlJazeera_Logo()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        NewsBlock(selectedCategory: $selectedCategory)
                        NewsFetchBlock(vm: newsVM, selectedCategory: selectedCategory)
                    }
                }
            }
        }
    }
}

#Preview {
    MainScreen()
}
