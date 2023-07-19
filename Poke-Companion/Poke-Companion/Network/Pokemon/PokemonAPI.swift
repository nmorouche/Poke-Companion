//
//  PokemonAPI.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation
import NetworkLayer

enum PokemonAPI {
    case getPokemonDetail(id: Int)
    case fetchPokemons(offset: Int, limit: Int)
}

extension PokemonAPI: NetworkService {
    var baseURL: String {
        "https://pokeapi.co/api/v2/pokemon/"
    }

    var path: String {
        switch self {
        case .getPokemonDetail(let id):
            return "\(id)"
        default:
            return ""
        }
    }

    var method: NetworkMethod {
        .get
    }

    var parameters: [String : String]? {
        switch self {
        case .fetchPokemons(let offset, let limit):
            return [
                "limit":"\(limit)",
                "offset": "\(offset)"
            ]
        default:
            return nil
        }
    }
    
    var body: Data? {
        nil
    }
}
