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
    
    var body: some View {
        VStack {
            Spacer()
            pokemonView
            Spacer()
            searchStack
            Spacer()
        }
        .overlay {
            if viewModel.isLoading {
                LoaderView()
            }
        }
        .alert(isPresented: $viewModel.isError, content: {
            Alert(
                title: Text("Error"),
                message: Text("An error occured, please checked that the ID entered is correct."),
                dismissButton: .cancel(Text("OK"))
            )
        })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocused = false
                    Task {
                        if let idInput = Int(viewModel.text),
                           viewModel.pokemon?.id != idInput {
                            await viewModel.getPokemonDetail(byId: idInput)
                        }
                    }
                }
            }
        }
    }
    
    private var pokemonView: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                CustomAsyncImage(url: pokemon.url)
                Text(pokemon.name.capitalized)
            } else {
                Image(systemName: "xmark.app")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Unknown")
            }
        }
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
                Task {
                    if let idInput = Int(viewModel.text),
                       viewModel.pokemon?.id != idInput {
                        await viewModel.getPokemonDetail(byId: idInput)
                    }
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
