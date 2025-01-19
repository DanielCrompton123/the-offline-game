//
//  SettingsView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var navigateToAccountCreationAgeView = false
    @Environment(GameKitViewModel.self) private var gameKitViewModel
    
    @AppStorage(K.userDefaultsUserAgeRawValueKey) private var userAgeRawValue: Int?
    
    var body: some View {
        NavigationStack {
            
            List {
                Section {
                    Group {
                        NavigationLink {
                            AttributionsView()
                        } label: {
                            Label("Attributions", systemImage: "hands.sparkles")
                        }
                        
                        NavigationLink(
                            destination: AccountCreationAgeView {
                                navigateToAccountCreationAgeView = false
                            },
                            isActive: $navigateToAccountCreationAgeView
                        ) {
                            Label("Change age", systemImage: "figure.and.child.holdinghands")
                        }
                    }
                    .frame(height: 50)
                }
                
                Section {
                    
                    if !gameKitViewModel.gameCenterEnabled {
                        Text("Please log into Game Center to get the most out of The Offline Game.")
                    }
                    
                    Group {
                        Button("Open Game Center dashboard", systemImage: "rectangle.on.rectangle") {
                            gameKitViewModel.openGKViewController(at: .dashboard)
                        }
                        Button("Open my Game Center profile", systemImage: "figure.wave"){
                            gameKitViewModel.openGKViewController(at: .localPlayerProfile)
                        }
                        Button("Open Game Center achievements", systemImage: "trophy") {
                            gameKitViewModel.openGKViewController(at: .achievements)
                        }
                    }
                    .frame(height: 50)
                    .disabled(!gameKitViewModel.gameCenterEnabled)
                    
                } header: {
                    Text("GAME CENTER")
                        .font(.main20)
                }

            }
            .font(.main20)
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    SettingsView()
}
