//
//  TabType.swift
//  AppRouter
//
//  Created by Nassim Morouche on 10/06/2025.
//

public protocol TabType: Hashable, CaseIterable, Identifiable, Sendable {
  var icon: String { get }
}
