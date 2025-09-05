//
//  EnhancedTypeFilterView.swift
//  Poke-Companion
//
//  Created by Assistant on 03/09/2025.
//

import SwiftUI

struct EnhancedTypeFilterView: View {
    let type: PokemonType
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Type icon/symbol
                ZStack {
                    Circle()
                        .fill(Color(hex: type.colorCode))
                        .frame(width: 32, height: 32)
                        .overlay {
                            Circle()
                                .stroke(
                                    isSelected ? Color.white : Color.clear,
                                    lineWidth: isSelected ? 2 : 0
                                )
                        }
                        .shadow(
                            color: Color(hex: type.colorCode).opacity(0.4),
                            radius: isSelected ? 8 : 4,
                            x: 0, y: 2
                        )
                    
                    Image(systemName: typeIcon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                // Type name
                Text(type.rawValue.capitalized)
                    .font(.custom("AvenirNext-Medium", size: 10))
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(InteractiveTypeButtonStyle(
            isSelected: isSelected,
            typeColor: Color(hex: type.colorCode)
        ))
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var typeIcon: String {
        switch type {
        case .normal: return "circle.fill"
        case .fighting: return "figure.boxing"
        case .flying: return "wind"
        case .poison: return "drop.fill"
        case .ground: return "mountain.2.fill"
        case .rock: return "cube.fill"
        case .bug: return "ant.fill"
        case .ghost: return "moon.fill"
        case .steel: return "gear"
        case .fire: return "flame.fill"
        case .water: return "drop.fill"
        case .grass: return "leaf.fill"
        case .electric: return "bolt.fill"
        case .psychic: return "brain.head.profile"
        case .ice: return "snowflake"
        case .dragon: return "sparkles"
        case .dark: return "moon.stars.fill"
        case .fairy: return "star.fill"
        case .shadow: return "questionmark"
        }
    }
}

struct InteractiveTypeButtonStyle: ButtonStyle {
    let isSelected: Bool
    let typeColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? typeColor.opacity(0.2) : Color.secondary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
        ForEach([PokemonType.fire, .water, .grass, .electric, .dragon, .fairy]) { type in
            EnhancedTypeFilterView(type: type, isSelected: type == .fire) {
                print("Tapped \(type.rawValue)")
            }
        }
    }
    .padding()
    .background(.regularMaterial)
}
