//
//  HomeView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import NetworkLayer

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel = .init()
    @FocusState var isFocused: Bool
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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
            .overlay {
                if viewModel.pokemons.isEmpty && viewModel.isLoading {
                    LoaderView()
                }
            }
            .alert(isPresented: $viewModel.isError) {
                Alert(
                    title: Text("Error"),
                    message: Text("An error occured, please checked that the ID entered is correct."),
                    dismissButton: .cancel(Text("OK"))
                )
            }
            .navigationTitle(Tab.home.navigationTitle)
        }
    }
    
    private var pokemonList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.pokemons) { pokemon in
                VStack(spacing: 5) {
                    HomeRowView(pokemon: pokemon)
                        .task {
                            if let lastId = viewModel.pokemons.last?.id,
                               pokemon.id == lastId {
                                await viewModel.fetchPokemons()
                            }
                        }
                }
            }
        }
        .padding()
    }
    
    private var searchStack: some View {
        HStack {
            Spacer()
            TextField("Enter an ID", text: $viewModel.text)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .padding(.vertical)
            Button {
                if isFocused {
                    isFocused = false
                }
            } label: {
                Text("SEARCH")
                    .bold()
            }
            .padding(.vertical)
            
            Spacer()
        }
        .background(Color.gray.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding()
    }
}

#Preview {
    HomeView()
}
