//
//  PokemonDetailView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import SwiftUI
import AppRouter

struct PokemonDetailView: View {
    
    @Environment(Router.self) var router
    @StateObject var viewModel: PokemonDetailViewModel
    
    init(pokemons: [Pokemon], index: Int) {
        _viewModel = StateObject(wrappedValue: .init(pokemons: pokemons, index: index))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { reader in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.pokemons.enumerated(), id:\.offset) { index, pokemon in
                            PokemonDetailRowView(pokemon: pokemon, size: geometry.size) {
                                router.popNavigation()
                            }
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onAppear {
                    reader.scrollTo(viewModel.index)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PokemonDetailView(pokemons: Pokemon.mockedPokemons, index: 0)
}
