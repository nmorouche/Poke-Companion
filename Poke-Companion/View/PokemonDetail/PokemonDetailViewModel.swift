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
    var pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
