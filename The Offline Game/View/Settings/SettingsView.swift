//
//  SettingsView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            
            List {
                NavigationLink {
                    AttributionsView()
                } label: {
                    Label("Attributions", systemImage: "hands.sparkles")
                }
                .font(.main20)
                
                
            }
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    SettingsView()
}
