//
//  ContentView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI
import NetworkLayer

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel = .init()
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
        .task {
            await viewModel.getPokemonDetail(byId: 1)
        }
    }
    
    private var pokemonView: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                CustomAsyncImage(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(pokemon.id).png")
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
            TextField("", text: $viewModel.text)
                .keyboardType(.phonePad)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
