//
//  SettingsView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI
import WishKit

struct SettingsView: View {
    
    @State private var navigateToAccountCreationAgeView = false
    @State private var clearAchievementsConfirmation = false

    @Environment(GameKitViewModel.self) private var gameKitViewModel
    
    @AppStorage(K.userDefaultsUserAgeRawValueKey) private var userAgeRawValue: Int?
    
    @AppStorage("numOffPds") private var numOfflinePeriods: Int = 0
    
    @State private var achievementsClearToastShows = false
    
    
    var body: some View {
        NavigationStack {
            
            List {
                
                // MAIN CONTENT
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
                        
                        NavigationLink {
                            WishKit.FeedbackListView().withNavigation()
                        } label: {
                            Label("Request a feature", systemImage: "bubbles.and.sparkles")
                        }
                        
                        NavigationLink {
                            OfflineRules()
                        } label: {
                            Label("See rules", systemImage: "list.bullet.rectangle")
                        }
                    }
                    .frame(height: 50)
                }
                
                
                // GAME CENTER
                Section {
                    
                    if !gameKitViewModel.gameCenterEnabled {
                        Text("PLEASE LOG INTO GAME CENTER to get the most out of The Offline Game.")
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
                        
                        Button("Clear achievements", systemImage: "trash") {
                            clearAchievementsConfirmation = true
                        }
                        .font(.main14)
                        .foregroundStyle(.smog)
                    }
                    .frame(height: gameKitViewModel.gameCenterEnabled ? 50 : nil)
                    .disabled(!gameKitViewModel.gameCenterEnabled)
                    .opacity(!gameKitViewModel.gameCenterEnabled ? 0.4 : 1)
                    
                } header: {
                    Label("GAME CENTER", systemImage: "gamecontroller")
                        .font(.main20)
                }

            }
            .font(.main20)
            .navigationTitle("Settings")
            
            .confirmationDialog("Are you sure you want to clear all your achievements? This will delete all of your progress!", isPresented: $clearAchievementsConfirmation, titleVisibility: .visible) {
                Button("Yes, clear achievements", role: .destructive) {
                    clearAchievementsAndStorage()
                }
                
                Button("No, cancel", role: .cancel) {
                    clearAchievementsConfirmation = false
                }
            }
            .toast(isPresented: $achievementsClearToastShows) {
                Label("Achievements have been cleared", systemImage: "exclamationmark.shield.fill")
            }
        }
    }
    
    
    private func clearAchievementsAndStorage() {
        
        Task {
            // Clear achievements
            await gameKitViewModel.achievementsViewModel?.clearAchievements()
            
            // Now show a toast
        }
    }

}

#Preview {
    let vm = {
       let vm = GameKitViewModel()
        vm.gameCenterEnabled = true
        return vm
    }()
    SettingsView()
        .environment(vm)
}
