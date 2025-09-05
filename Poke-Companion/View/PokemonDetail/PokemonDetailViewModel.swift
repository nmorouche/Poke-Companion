//
//  PokemonDetailViewModel.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import Foundation
import Injector

@Observable
final class PokemonDetailViewModel: BaseViewModel {
    var pokemons: [Pokemon]
    var index: Int
    
    var currentPokemon: Pokemon {
        pokemons[index]
    }
    
    init(pokemons: [Pokemon], index: Int) {
        self.pokemons = pokemons
        self.index = index
    }
}
