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
                Group {
                    NavigationLink {
                        AttributionsView()
                    } label: {
                        Label("Attributions", systemImage: "hands.sparkles")
                    }
                    
                    NavigationLink {
//                        AccountCreationAgeView {
//                            // Action when age is changed:
//                            // dismiss it.
//                        }
                        AccountCreationAgeView(insideOnboarding: false)
                    } label: {
                        Label("Change age", systemImage: "figure.and.child.holdinghands")
                    }
                }
                .frame(height: 50) // too big?
            }
            .font(.main20)
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    SettingsView()
}
