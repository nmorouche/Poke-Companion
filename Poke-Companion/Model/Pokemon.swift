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

struct Pokemon: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let order: Int
    private let typesValue: [TypesResult]
    var types: [PokemonType] {
        typesValue.compactMap { $0.type.name }
    }
    
    var url: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(id).png"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case order
        case typesValue = "types"
    }
}

extension Pokemon {
    static var mockedPokemon: Pokemon = .init(id: 1, name: "Bulbizarre", order: 1, typesValue: [.mockedTypesResult])
    static var mockedPokemon2: Pokemon = .init(id: 2, name: "Salameche", order: 2, typesValue: [.mockedTypesResult])
    static var mockedPokemons: [Pokemon] = [
        mockedPokemon,
        mockedPokemon2
    ]
}
