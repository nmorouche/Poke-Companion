//
//  AppError.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import Foundation

enum AppError: Error {

    case generic

    init() { self = .generic }

    init(error: Error) { self = .generic }
}

extension AppError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .generic:
            return NSLocalizedString("Generic error.", comment: "App Generic Error")
        }
    }

}
