//
//  NewsBlock.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI

enum SelectedCategory {
    case latest
    case following
}


struct NewsBlock: View {
    
    @State private var selectedCategory: SelectedCategory = .latest
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button{
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedCategory = .latest
                    }
                } label: {
                    headingText(
                        "Latest",
                        active: selectedCategory == .latest
                    )
                }
                Button{
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedCategory = .following
                    }
                } label: {
                    headingText(
                        "Following",
                        active: selectedCategory == .following
                    )
                }
            }
            .frame(maxWidth: .infinity)

            SlidingAnimation
                .frame(height: 2)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

extension NewsBlock{
    private func headingText(
        _ text: String,
        active: Bool
    ) -> some View {
        Text(text)
            .font(.title2.weight(.semibold))
            .foregroundStyle(
                active ? .white : .white.opacity(0.6)
            )
            .frame(maxWidth: .infinity)
    }
    
    private var SlidingAnimation: some View {
        GeometryReader { proxy in
            let width = proxy.size.width / 2

            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.white.opacity(0.25))
                    .frame(height: 1)

                Rectangle()
                    .fill(Color.white)
                    .frame(width: width, height: 2)
                    .offset(x: selectedCategory == .latest ? 0 : width)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedCategory)
            }
        }
    }
    
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NewsBlock()
    }
}
