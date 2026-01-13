//
//  NewsFetchBlock.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI

struct NewsFetchBlock: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 8){
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .overlay(
                        Text("Fetching the news block...")
                            .foregroundStyle(Color.black)
                    )
                HStack(spacing: 8){
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
                VStack(spacing: 0) {
                    // Top row: circle + text
                    HStack(alignment: .center, spacing: 8) {
                        // Leading column (fixed width)
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.white.opacity(0.9))
                                .frame(width: 15, height: 15)
                        }
                        .frame(width: 15, alignment: .center)

                        // Label
                        Text("Top Headline")
                            .foregroundStyle(Color.white.opacity(0.9))
                            .font(.subheadline)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 6)

                    // Connector row: put the line in the same leading column
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
                                .frame(width: 2, height: 25)
                        }
                        .frame(width: 15, alignment: .center)

                        // Spacer for label column
                        Spacer()
                    }

                    // Bottom row: circle + text
                    HStack(alignment: .center, spacing: 8) {
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

                        Text("Breaking Story")
                            .foregroundStyle(Color.white.opacity(0.9))
                            .font(.subheadline)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(8)
            }
        }
    }
}

#Preview {
    NewsFetchBlock()
}
