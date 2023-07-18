//
//  LoaderView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 17/07/2023.
//

import SwiftUI

struct LoaderView: View {
    
    let start = Date()
    
    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.white)
                    .circleLoader(
                        seconds: context.date.timeIntervalSince1970 - self.start.timeIntervalSince1970
                    )
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoaderView()
}
