//
//  Pokemon.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

struct TypesResult: Codable, Equatable, Hashable {
    let slot: Int
    let type: PokemonTypes
    
    static var mockedTypesResult: TypesResult = .init(slot: 1, type: .mockedType)
}

struct Abilities: Codable, Equatable, Hashable {
    let slot: Int
    let is_hidden: Bool
    let ability: Ability
}

struct Ability: Codable, Equatable, Hashable {
    let name: String
    let url: String
}

struct Stats: Codable, Equatable, Hashable {
    let base_stat: Int
    let effort: Int
    let stat: Stat
}

struct Stat: Codable, Equatable, Hashable {
    let name: String
    let url: String
}

struct Pokemon: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let order: Int
    internal let typesValue: [TypesResult]
    var types: [PokemonType] {
        typesValue.compactMap { $0.type.name }
    }
    let abilities: [Abilities]
    internal let baseHeight: Int
    internal let baseWeight: Int
    var height: Float {
        Float(baseHeight) / 10
    }
    var weight: Float {
        Float(baseWeight) / 10
    }
    let stats: [Stats]
    
    var url: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(id).png"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case order
        case typesValue = "types"
        case abilities
        case baseHeight = "height"
        case baseWeight = "weight"
        case stats
    }
}

extension Pokemon {
    static var mockedPokemon: Pokemon = .init(id: 1, name: "Bulbizarre", order: 1, typesValue: [.mockedTypesResult], abilities: [], baseHeight: 0, baseWeight: 0, stats: [])
    static var mockedPokemon2: Pokemon = .init(id: 2, name: "Salameche", order: 2, typesValue: [.mockedTypesResult], abilities: [], baseHeight: 0, baseWeight: 0, stats: [])
    static var mockedPokemons: [Pokemon] = [
        mockedPokemon,
        mockedPokemon2
    ]
}
