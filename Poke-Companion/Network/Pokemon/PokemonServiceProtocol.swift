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
        let result = await provider.load(service: .fetchPokemons(offset: offset, limit: limit))
        switch result {
        case .success(let data):
            do {
                let pokemonListResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                let pokemons = await getPokemonDetailsFromPokemonListResponse(pokemonsDTO: pokemonListResponse)
                return .success((pokemonListResponse.count, pokemons))
            } catch {
                return .failure(.generic)
            }
        case .failure(_):
            return .failure(.generic)
        }
    }
    
    private func getPokemonDetailsFromPokemonListResponse(pokemonsDTO: PokemonListResponse) async -> [Pokemon] {
        let pokemons = await withTaskGroup(of: (Pokemon?, Int?).self, returning: [Pokemon].self) { group in
            for result in pokemonsDTO.results {
                if let id = result.id {
                    group.addTask {
                        let result = await self.getPokemonDetail(byId: id)
                        switch result {
                        case .success(let pokemon):
                            return (pokemon, nil)
                        case .failure(_):
                            return (nil, id)
                        }
                    }
                }
            }
            
            var pokemons: [Pokemon] = []
            var failedIds: [Int] = []
            
            for await (pokemon, failedId) in group {
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                } else if let failedId = failedId {
                    failedIds.append(failedId)
                }
            }
            
            return pokemons.sorted { $0.id < $1.id }
        }
        
        return pokemons
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
