//
//  Sheet.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

@testable import AppRouter

enum Sheet: SheetType {
    case settings
    case profile
    
    var id: Int { hashValue }
}
