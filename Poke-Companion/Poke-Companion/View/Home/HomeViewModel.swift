//
//  HomeViewModel.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import Injector

final class HomeViewModel: BaseViewModel {
    
    @Published var pokemons: [Pokemon] = []
    @Published var text: String = ""
    @Published var offset: Int = 0
    private var limit: Int = 24
    private var maximumPokemonsCount: Int = -1
    
    @Inject var pokemonService: PokemonService
    
    override init() {
        super.init()
        
        Task { [weak self] in
            guard let self else { return }
            await fetchPokemons()
        }
    }
    
    @MainActor
    func fetchPokemons() async {
        if maximumPokemonsCount == offset || isLoading { return }
        
        isLoading = true
        let result = await pokemonService.fetchPokemons(offset: offset, limit: limit)
        isLoading = false
        offset += limit
        switch result {
        case .success((let count, let pokemons)):
            self.maximumPokemonsCount = count
            self.pokemons.append(contentsOf: pokemons)
        case .failure(let failure):
            error = failure
        }
    }
}
