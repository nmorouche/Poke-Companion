//
//  BubbleTypeView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import SwiftUI

struct BubbleTypeView: View {
    
    let types: [PokemonType]
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(types, id: \.rawValue) { type in
                Text(type.rawValue.capitalized)
                    .font(.custom("AvenirNext-Bold", size: 11))
                    .frame(width: 45)
                    .padding(.horizontal)
                    .background(in: RoundedRectangle(cornerRadius: 25))
                    .backgroundStyle(.white.opacity(0.5))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    BubbleTypeView(types: [.dark, .dragon])
}
