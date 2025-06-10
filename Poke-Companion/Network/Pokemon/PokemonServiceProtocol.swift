//
//  PokemonServiceProtocol.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import NetworkLayer

protocol PokemonServiceProtocol {
    func getPokemonDetail(byId id: Int) async -> Result<Pokemon, AppError>
    func fetchPokemons(offset: Int, limit: Int) async -> Result<(Int, [Pokemon]), AppError>
}

class PokemonService: PokemonServiceProtocol {
    
    private let provider = NetworkProvider<PokemonAPI>()
    
    func fetchPokemons(offset: Int, limit: Int) async -> Result<(Int, [Pokemon]), AppError> {
        var pokemons: [Pokemon] = []
        let result = await provider.load(service: .fetchPokemons(offset: offset, limit: limit))
        switch result {
        case .success(let data):
            do {
                let pokemonListDTO = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                for result in pokemonListDTO.results {
                    if let id = result.id {
                        let pokemon = await getPokemonDetail(byId: id)
                        switch pokemon {
                        case .success(let pokemon):
                            pokemons.append(pokemon)
                        case .failure(_):
                            break
                        }
                    }
                }
                return .success((pokemonListDTO.count, pokemons))
            } catch {
                return .failure(.generic)
            }
        case .failure(_):
            return .failure(.generic)
        }
    }
    
    func getPokemonDetail(byId id: Int) async -> Result<Pokemon, AppError> {
        let result = await provider.load(service: .getPokemonDetail(id: id))
        switch result {
        case .success(let data):
            do {
                let pokemonDetailDTO = try JSONDecoder().decode(Pokemon.self, from: data)
                return .success(pokemonDetailDTO)
            } catch {
                return .failure(.generic)
            }
        case .failure(_):
            return .failure(.generic)
        }
    }
}
