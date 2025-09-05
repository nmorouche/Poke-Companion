//
//  CustomAsyncImage.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI
import NukeUI

struct CustomAsyncImage: View {
    
    let url: String
    var width: CGFloat = 250
    var height: CGFloat = 250
    
    var body: some View {
        if let url = URL(string: url) {
            LazyImage(url: url) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if state.error != nil {
                    Color
                        .gray
                        .overlay(
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .scaleEffect(0.3)
                                .opacity(0.8)
                                .padding(.horizontal)
                        )
                } else {
                    ProgressView()
                }
            }
            .frame(width: width, height: height)
        }
    }
}

#Preview {
    CustomAsyncImage(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png")
}
