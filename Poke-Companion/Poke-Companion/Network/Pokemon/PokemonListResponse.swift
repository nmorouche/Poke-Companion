//
//  PokemonListResponse.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import Foundation

struct PokemonListResults: Codable {
    let name: String
    let url: String
    
    var id: Int? {
        if let last = url.split(separator: "/").map({ String($0) }).last {
            return Int(last)
        }
        return nil
    }
}

struct PokemonListResponse: Codable {
    let count: Int
    let results: [PokemonListResults]
}
