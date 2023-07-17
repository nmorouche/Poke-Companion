//
//  PokemonDetailService.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import NetworkLayer

protocol PokemonDetailServiceProtocol {
    func getPokemonDetail(byId id: Int) async -> Result<Pokemon, AppError>
}

class PokemonDetailService: PokemonDetailServiceProtocol {
    
    private let provider = NetworkProvider<PokemonDetailAPI>()
    
    func getPokemonDetail(byId id: Int) async -> Result<Pokemon, AppError> {
        let result = await provider.load(service: .getPokemonDetail(id: id))
        switch result {
        case .success(let data):
            do {
                let pokemonDetailDTO = try JSONDecoder().decode(Pokemon.self, from: data)
                return .success(pokemonDetailDTO)
            } catch {
                return .failure(AppError.generic)
            }
        case .failure(_):
            return .failure(AppError.generic)
        }
    }
}
