//
//  HomeViewModel.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import Injector

final class HomeViewModel: BaseViewModel {
    
    @Published var pokemon: Pokemon?
    @Published var text: String = ""
    
    @Inject var pokemonDetailService: PokemonDetailServiceProtocol
    
    override init() {
        super.init()
        
        Task { [weak self] in
            guard let self else { return }
            await getPokemonDetail(byId: 1)
        }
    }
    
    @MainActor
    func getPokemonDetail(byId id: Int) async {
        if isLoading { return }
        
        isLoading = true
        let result = await pokemonDetailService.getPokemonDetail(byId: id)
        isLoading = false
        switch result {
        case .success(let pokemon):
            self.pokemon = pokemon
        case .failure(let failure):
            error = failure
        }
    }
}
