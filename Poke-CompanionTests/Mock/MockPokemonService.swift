//
//  MockPokemonService.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 05/10/2025.
//

import XCTest
@testable import Poke_Companion

// MARK: - Mock PokemonService
class MockPokemonService: PokemonServiceProtocol {
    var fetchPokemonsResult: Result<(Int, [Pokemon]), AppError> = .success((0, []))
    var getPokemonDetailResult: Result<Pokemon, AppError> = .success(.mockedPokemon)
    var fetchPokemonsCallCount = 0
    var getPokemonDetailCallCount = 0
    var lastFetchOffset: Int?
    var lastFetchLimit: Int?
    var fetchDelay: TimeInterval = 0

    func fetchPokemons(offset: Int, limit: Int) async -> Result<(Int, [Pokemon]), AppError> {
        fetchPokemonsCallCount += 1
        lastFetchOffset = offset
        lastFetchLimit = limit

        if fetchDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(fetchDelay * 1_000_000_000))
        }

        return fetchPokemonsResult
    }

    func getPokemonDetail(byId id: Int) async -> Result<Pokemon, AppError> {
        getPokemonDetailCallCount += 1
        return getPokemonDetailResult
    }
}
