//
//  HomeViewModel.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import Injector

final class HomeViewModel: BaseViewModel {
    
    @Inject var pokemonService: PokemonService

    @Published private var _pokemons: [Pokemon] = []
    @Published var searchText: String = ""
    @Published var offset: Int = 0
    @Published var selectedFilter: PokemonType?
    private var limit: Int = 100
    var maximumPokemonsCount: Int = -1
    
    var pokemons: [Pokemon] {
        if let selectedFilter {
            return _pokemons.filter({ $0.types.contains(selectedFilter) })
        }
        
        return _pokemons
    }
    
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
        
        switch result {
        case .success((let count, let pokemons)):
            self.maximumPokemonsCount = count
            self._pokemons.append(contentsOf: pokemons)
            offset += limit
        case .failure(let failure):
            error = failure
        }
    }
    
    func hasMorePokemons() -> Bool {
        return maximumPokemonsCount == -1 || offset < maximumPokemonsCount
    }
}
