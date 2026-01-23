//
//  Footer.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI

enum ChosenCategory {
    case news
    case watch
    case topics
    case profile
}

struct Footer: View {
    @Binding var selectedTab: ChosenCategory
    
    var body: some View {
        HStack(spacing: 0) {
            footerButton(
                icon: "newspaper",
                title: "News",
                category: .news
            )
            footerButton(
                icon: "play.rectangle",
                title: "Watch",
                category: .watch
            )
            footerButton(
                icon: "text.badge.star",
                title: "Topics",
                category: .topics
            )
            footerButton(
                icon: "person.crop.circle",
                title: "Profile",
                category: .profile
            )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.95))
    }
}

extension Footer {
    // MARK: - Footer Button
    private func footerButton(
        icon: String,
        title: String,
        category: ChosenCategory
    ) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = category
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(
                        selectedTab == category ? .white : .white.opacity(0.3)
                    )
                Text(title)
                    .font(.caption)
                    .foregroundColor(
                        selectedTab == category ? .white : .white.opacity(0.6)
                    )
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Footer(selectedTab: .constant(.news))
}
