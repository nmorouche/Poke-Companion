//
//  HomeView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import NetworkLayer

struct HomeView: View {
    @Environment(Router.self) var router
    @StateObject var viewModel: HomeViewModel = .init()
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    pokemonList
                    
                    if !viewModel.pokemons.isEmpty && viewModel.isLoading {
                        HStack {
                            LottieView(filename: "pokeball")
                                .frame(width: 20)
                            LottieView(filename: "pokeball")
                                .frame(width: 20)
                            LottieView(filename: "pokeball")
                                .frame(width: 20)
                        }
                        .frame(width: 300, height: 50)
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                toolbarView
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
            .overlay {
                if viewModel.pokemons.isEmpty && viewModel.isLoading {
                    LoaderView()
                }
            }
        }
    }
    
    private var pokemonList: some View {
        LazyVGrid(columns: columns) {
            ForEach(Array(viewModel.pokemons.enumerated()), id: \.element.id) { index, pokemon in
                VStack(spacing: 5) {
                    HomeRowView(pokemon: pokemon)
                        .onTapGesture {
                            router.navigateTo(.detail(pokemon))
                        }
                        .onAppear {
                            if shouldLoadMore(for: index) {
                                Task {
                                    await viewModel.fetchPokemons()
                                }
                            }
                        }
                }
            }
        }
        .padding()
    }
    
    private func shouldLoadMore(for index: Int) -> Bool {
        let threshold = 5 // Load more when 5 items from the end
        return viewModel.hasMorePokemons() && 
               index >= viewModel.pokemons.count - threshold
    }
    
    @State private var isFilterExpanded = false
    
    private var toolbarView: some View {
        PokemonFilterToolbarView(
            selectedFilter: $viewModel.selectedFilter,
            isFilterExpanded: $isFilterExpanded
        )
    }
    
}

#Preview {
    HomeView()
        .environment(Router(initialTab: .home))
}
