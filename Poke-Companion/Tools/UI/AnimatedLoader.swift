//
//  AnimatedLoader.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI

struct AnimatedLoader: View {
    
    let startTime: Date = Date()
    
    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.white)
                    .circleLoader(
                        seconds: context.date.timeIntervalSince1970 - startTime.timeIntervalSince1970
                    )
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    AnimatedLoader()
}
