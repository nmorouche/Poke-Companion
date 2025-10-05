//
//  AppDestination.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import SwiftUI
import AppRouter

struct AppDestination: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: RouterDestination.self) { destination in
                switch destination {
                case .detail(let pokemon):
                    PokemonDetailView(pokemon: pokemon)
                case .about:
                    EmptyView()
                }
            }
    }
}

extension View {
    func withAppDestination() -> some View {
        modifier(AppDestination())
    }
}