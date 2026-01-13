//
//  MainScreen.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

// This is the main screen that will have the front page of the news

import SwiftUI

struct MainScreen: View {
    
    private let colums = [
        GridItem(.flexible(), spacing: 16)
    ]
    
    
    var body: some View {
        AlJazeera_Logo()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16){
                NewsBlock()
                
                LazyVGrid(columns: self.colums, spacing: 16) {
                    ForEach(0..<10, id: \.self) { _ in
                        NewsFetchBlock()
                    }
                }
            }
        }
        Spacer()
        Footer()
    }
}

#Preview {
    MainScreen()
}

