//
//  SettingsView.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    Text("View")
                } label: {
                    Text("About us")
                }
            } footer: {
                HStack(alignment: .center) {
                    Spacer()
                    Text("v.\(AppInfo.versionNumber)")
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    SettingsView()
}
