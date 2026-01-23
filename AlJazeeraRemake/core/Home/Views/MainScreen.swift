//
//  MainScreen.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: ChosenCategory = .news
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area based on selected tab
            TabView(selection: $selectedTab) {
                NewsTab()
                    .tag(ChosenCategory.news)
                
                WatchTab()
                    .tag(ChosenCategory.watch)
                
                TopicsTab()
                    .tag(ChosenCategory.topics)
                
                ProfileTab()
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
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                AlJazeera_Logo()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        NewsBlock()
                        NewsFetchBlock()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Watch Tab
struct WatchTab: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Watch Section")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // Add your watch content here
            }
            .navigationTitle("Watch")
        }
    }
}

// MARK: - Topics Tab
struct TopicsTab: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Topics Section")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // Add your topics content here
            }
            .navigationTitle("Topics")
        }
    }
}

// MARK: - Profile Tab
struct ProfileTab: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Section")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // Add your profile content here
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    MainScreen()
}
