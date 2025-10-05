//
//  BaseStatsView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import SwiftUI

struct BaseStatsView: View {
    let stats: [Stats]
    
    private let maxStatValue: CGFloat = 255 // Maximum possible stat value for Pokemon
    @State private var isVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(stats.enumerated()), id: \.element.stat.name) { index, stat in
                StatProgressRow(
                    name: displayName(for: stat.stat.name),
                    value: stat.base_stat,
                    maxValue: maxStatValue,
                    color: colorForStat(stat.stat.name),
                    animationDelay: Double(index) * 0.1,
                    isVisible: isVisible
                )
            }
            
            if let totalStats = calculateTotalStats() {
                Divider()
                    .padding(.vertical, 4)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3).delay(Double(stats.count) * 0.1 + 0.2), value: isVisible)
                
                StatProgressRow(
                    name: "Total",
                    value: totalStats,
                    maxValue: maxStatValue * 6, // 6 stats total
                    color: .gray,
                    animationDelay: Double(stats.count) * 0.1 + 0.3,
                    isVisible: isVisible
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 120)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
        .onDisappear {
            isVisible = false
        }
    }
    
    private func displayName(for statName: String) -> String {
        switch statName {
        case "hp":
            return "HP"
        case "attack":
            return "Attack"
        case "defense":
            return "Defense"
        case "special-attack":
            return "Sp. Atk"
        case "special-defense":
            return "Sp. Def"
        case "speed":
            return "Speed"
        default:
            return statName.capitalized
        }
    }
    
    private func colorForStat(_ statName: String) -> Color {
        switch statName {
        case "hp":
            return .red
        case "attack":
            return .orange
        case "defense":
            return .blue
        case "special-attack":
            return .purple
        case "special-defense":
            return .green
        case "speed":
            return .pink
        default:
            return .gray
        }
    }
    
    private func calculateTotalStats() -> Int? {
        guard !stats.isEmpty else { return nil }
        return stats.reduce(0) { $0 + $1.base_stat }
    }
}

struct StatProgressRow: View {
    let name: String
    let value: Int
    let maxValue: CGFloat
    let color: Color
    let animationDelay: Double
    let isVisible: Bool
    
    private var progress: CGFloat {
        min(CGFloat(value) / maxValue, 1.0)
    }
    
    private var animatedProgress: CGFloat {
        isVisible ? progress : 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Stat name
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .frame(width: 70, alignment: .leading)
                .opacity(isVisible ? 1 : 0)
                .offset(x: isVisible ? 0 : -20)
                .animation(.easeOut(duration: 0.4).delay(animationDelay), value: isVisible)
            
            // Stat value
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .frame(width: 30, alignment: .trailing)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(animationDelay + 0.1), value: isVisible)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .scaleX(isVisible ? 1 : 0, anchor: .leading)
                        .animation(.easeOut(duration: 0.3).delay(animationDelay + 0.05), value: isVisible)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * animatedProgress, height: 6)
                        .animation(.easeOut(duration: 0.6).delay(animationDelay + 0.2), value: isVisible)
                }
            }
            .frame(height: 6)
        }
    }
}

extension View {
    func scaleX(_ scale: CGFloat, anchor: UnitPoint = .center) -> some View {
        self.scaleEffect(x: scale, y: 1, anchor: anchor)
    }
}

#Preview {
    BaseStatsView(stats: [
        Stats(base_stat: 45, effort: 0, stat: Stat(name: "hp", url: "")),
        Stats(base_stat: 60, effort: 0, stat: Stat(name: "attack", url: "")),
        Stats(base_stat: 48, effort: 0, stat: Stat(name: "defense", url: "")),
        Stats(base_stat: 65, effort: 0, stat: Stat(name: "special-attack", url: "")),
        Stats(base_stat: 65, effort: 0, stat: Stat(name: "special-defense", url: "")),
        Stats(base_stat: 45, effort: 0, stat: Stat(name: "speed", url: ""))
    ])
}