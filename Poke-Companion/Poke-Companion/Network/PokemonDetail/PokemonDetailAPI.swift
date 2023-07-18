//
//  PokemonDetailAPI.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import NetworkLayer

enum PokemonDetailAPI {
    case getPokemonDetail(id: Int)
}

extension PokemonDetailAPI: NetworkService {
    var baseURL: String {
        "https://pokeapi.co/api/v2/pokemon/"
    }

    var path: String {
        switch self {
        case .getPokemonDetail(let id):
            return "\(id)"
        }
    }

    var method: NetworkMethod {
        .get
    }

    var parameters: [String : String]? {
        nil
    }
    
    var body: Data? {
        nil
    }
}
