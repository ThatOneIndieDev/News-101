//
//  AnalyticsTab.swift
//  AlJazeeraRemake
//
//  Created by Codex on 07/02/2026.
//

import SwiftUI

struct AnalyticsTab: View {
    @StateObject private var vm: AnalyticsViewModel
    
    init(newsVM: NewsArticleViewModel) {
        _vm = StateObject(wrappedValue: AnalyticsViewModel(newsVM: newsVM))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        header
                        
                        LazyVStack(spacing: 16) {
                            ForEach(vm.summaries) { summary in
                                AnalyticsSummaryCard(summary: summary)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

private extension AnalyticsTab {
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Fast summaries")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            
            Text("Tap a card to reveal prediction graphs when available.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

private struct AnalyticsSummaryCard: View {
    let summary: AnalyticsSummary
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    summaryChips
                    
                    Text(summary.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                
                if summary.hasPrediction {
                    Text("Prediction")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                }
            }
            
            HStack {
                Text(summary.sourceName)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                
                Spacer()
                
                if summary.hasPrediction {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(isExpanded ? "Hide Graph" : "View Graph")
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            if summary.hasPrediction && isExpanded {
                PredictionGraphView(values: summary.predictionSeries)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture {
            guard summary.hasPrediction else { return }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }
    }
    
    private var summaryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(summary.summaryWords, id: \.self) { word in
                    Text(word)
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

private struct PredictionGraphView: View {
    let values: [Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prediction trend")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))
            
            GeometryReader { proxy in
                let points = normalizedPoints(in: proxy.size)
                
                ZStack {
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: first)
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: CGPoint(x: first.x, y: proxy.size.height))
                        for point in points {
                            path.addLine(to: point)
                        }
                        if let last = points.last {
                            path.addLine(to: CGPoint(x: last.x, y: proxy.size.height))
                        }
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [Color.red.opacity(0.35), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .frame(height: 120)
            
            Text("Next 7 data points")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(10)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard values.count > 1 else { return [] }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        let range = max(maxValue - minValue, 0.001)
        let stepX = size.width / CGFloat(values.count - 1)
        
        return values.enumerated().map { index, value in
            let x = CGFloat(index) * stepX
            let normalized = (value - minValue) / range
            let y = size.height - (CGFloat(normalized) * size.height)
            return CGPoint(x: x, y: y)
        }
    }
}

#Preview {
    AnalyticsTab(newsVM: NewsArticleViewModel())
        .preferredColorScheme(.dark)
}
