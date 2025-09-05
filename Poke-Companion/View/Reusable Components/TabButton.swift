//
//  TabButton.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 12/06/2025.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundStyle(isSelected ? .black : .gray)
                
                Rectangle()
                    .fill(isSelected ? .blue : .clear)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}