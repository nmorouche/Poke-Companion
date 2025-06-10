//
//  Pokemon.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

struct TypesResult: Codable {
    let slot: Int
    let type: PokemonTypes
}

extension TypesResult {
    static var mockedTypesResult: TypesResult = .init(slot: 0, type: .mockedPokemonTypes)
}

struct Pokemon: Codable, Identifiable {
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
    
    private enum CodingKeys: String, CodingKey, Codable {
        case id
        case name
        case order
        case typesValue = "types"
    }
}

extension Pokemon {
    static var mockedPokemon: Pokemon = .init(id: 1, name: "Bulbizarre", order: 1, typesValue: [.mockedTypesResult])
}
