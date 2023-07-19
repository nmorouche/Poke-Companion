//
//  CustomAsyncImage.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct CustomAsyncImage: View {
    
    let url: String
    var width: CGFloat = 250
    var height: CGFloat = 250
    
    var body: some View {
        if let url = URL(string: url) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
            } placeholder: {
                Image(systemName: "camera.metering.unknown")
            }
            .frame(width: width, height: height)
        }
    }
}

#Preview {
    CustomAsyncImage(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png")
}
