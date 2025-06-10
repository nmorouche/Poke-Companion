//
//  PokemonTypes.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import Foundation

enum PokemonType: String, Codable {
    case normal = "normal"
    case fighting = "fighting"
    case flying = "flying"
    case poison = "poison"
    case ground = "ground"
    case rock = "rock"
    case bug = "bug"
    case ghost = "ghost"
    case steel = "steel"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
    case dark = "dark"
    case fairy = "fairy"
    case shadow = "shadow"
    
    var colorCode: String {
        switch self {
        case .normal:
            "#A8A77A"
        case .fighting:
            "#C22E28"
        case .flying:
            "#A98FF3"
        case .poison:
            "#A33EA1"
        case .ground:
            "#E2BF65"
        case .rock:
            "#B6A136"
        case .bug:
            "#A6B91A"
        case .ghost:
            "#735797"
        case .steel:
            "#B7B7CE"
        case .fire:
            "#EE8130"
        case .water:
            "#6390F0"
        case .grass:
            "#7AC74C"
        case .electric:
            "#F7D02C"
        case .psychic:
            "#F95587"
        case .ice:
            "#96D9D6"
        case .dragon:
            "#6F35FC"
        case .dark:
            "#705746"
        case .fairy:
            "#D685AD"
        case .shadow:
            "#A0FF7A"
        }
    }
}

struct PokemonTypes: Codable {
    let name: PokemonType
    let url: String
}

extension PokemonTypes {
    static var mockedPokemonTypes: PokemonTypes = .init(name: .grass, url: "")
}
