//
//  HomeRowView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 19/07/2023.
//

import SwiftUI

struct HomeRowView: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("#\(pokemon.id)")
                        .font(.custom("AvenirNext-Bold", size: 11))
                        .foregroundStyle(.black.opacity(0.5))
                    CustomAsyncImage(url: pokemon.url, width: 20, height: 65)
                        .padding(.horizontal)
                }
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(pokemon.name.capitalized)
                        .font(.custom("AvenirNext-Heavy", size: 14))
                        .foregroundStyle(.white)
                    BubbleTypeView(types: pokemon.types)
                    Spacer()
                }
                .padding(.top, 10)
                Spacer()
            }
        }
        .padding()
        .frame(height: 90)
        .background(Color(hex: pokemon.types.first?.colorCode ?? "#FFFFFF"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HomeRowView(pokemon: .mockedPokemon)
}
