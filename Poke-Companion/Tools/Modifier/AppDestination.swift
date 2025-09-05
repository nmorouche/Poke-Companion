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
                case .detail(let pokemons, let index):
                    PokemonDetailView(pokemons: pokemons, index: index)
                case .about:
                    EmptyView()
                }
            }
    }
}
