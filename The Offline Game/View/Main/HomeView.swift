//
//  HomeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import ActivityKit
import StoreKit


struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.requestReview) private var requestReview
    
    @AppStorage("numOffPds") private var numOffPds: Int = 0
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @Environment(PermissionsViewModel.self) private var permissionsViewModel
    @Environment(LiveActivityViewModel.self) private var liveActivityViewModel
    @Environment(OfflineCountViewModel.self) private var offlineCountViewModel
    @Environment(GameKitViewModel.self) private var gameKitViewModel

    // If the user has disabled notifications in settings behind our backs (while the app was closed), check if they are now denied and warn them if so.
    @State private var shouldShowNotificationWarning = false
    
    // Show or hide settings view
    @State private var settingsIsOpen = false
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        @Bindable var offlineCountViewModel = offlineCountViewModel
        
        NavigationStack {
            
            // CONTENT
            
            VStack {
                
                Spacer()
                
                OfflineHeader()
                
                Spacer()
                
                Text("\(Text(String(offlineCountViewModel.count)).foregroundStyle(.ruby)) people are offline right now, competing to see who can avoid their phone the longest.\n\(Text("Up for the challenge?").foregroundStyle(colorScheme == .light ? .black : .white))")
                    .textCase(.uppercase)
                    .contentTransition(.numericText(countsDown: true))
                    .font(.main20)
                    .foregroundStyle(.smog)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    offlineViewModel.isPickingDuration = true
                } label: {
                    Label {
                        Text("Go offline")
                    } icon: {
                        Image(.offlinePhone)
                            .resizable()
                            .scaledToFit()
                    }
                    
                }
                .buttonStyle(FilledRedButtonStyle())
                
            }
            
            // DURATION PICKER (and tips)
            .sheet(isPresented: $offlineViewModel.isPickingDuration) {
                
                // On dismiss, (of either the duration picker or tips) if we are NOT going online then make the access point appear
                if !offlineViewModel.state.isOffline {
                    gameKitViewModel.openAccessPoint()
                }
                
            } content: {
                OfflineDurationPickerView()
                    .onAppear(perform: gameKitViewModel.hideAccessPoint)
            }
            
            // CONGRATS VIEW
            .sheet(
                isPresented: $offlineViewModel.userShouldBeCongratulated,
                onDismiss: resetIfNotInOvertime
            ) {
                CongratulatoryView()
            }
            
            // FAILURE VIEW
            .sheet(isPresented: $offlineViewModel.userDidFail) {
                // on dismiss
                gameKitViewModel.openAccessPoint()
                offlineViewModel.resetOfflineTime()
            } content: {
                FailureView()
            }
            
            // SETTINGS VIEW
            .sheet(isPresented: $settingsIsOpen) {
                SettingsView()
                    .onAppear(perform: gameKitViewModel.hideAccessPoint)
                    .onDisappear(perform: gameKitViewModel.openAccessPoint)
            }
            
            // NOTIFICATION WARNING
            .fullScreenCover(
                isPresented: $shouldShowNotificationWarning,
                onDismiss: gameKitViewModel.openAccessPoint
            ) {
                NotificationPermissionView()
                    .onAppear(perform: gameKitViewModel.hideAccessPoint)
            }
            
            // OFFLINE
            .fullScreenCover(
                isPresented: $offlineViewModel.state.isOffline,
                onDismiss: {
                    gameKitViewModel.openAccessPoint()
                    // Also request a review IF this is the 5th offline time
                    if numOffPds == 5 {
                        requestReview()
                    }
                }
            ) {
                OfflineView()
                    .onAppear(perform: gameKitViewModel.hideAccessPoint)
            }
            
            // LOAD NOTIFICATION STATUS
            .task(priority: .high) {
                await permissionsViewModel.loadNotificationStatus()
                await MainActor.run {
                    shouldShowNotificationWarning = permissionsViewModel.notificationStatus == .denied
                }
            }
            
            // SETTINGS BUTTON
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        settingsIsOpen = true
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                    .font(.main14)
                    .tint(.smog)
                }
            }
            
            // add an alert for errors with the offline count
            .alert("Error recording offline count",
                   isPresented: $offlineViewModel.error.condition { $0 != nil }) {
                
                Button("OK", role: .cancel) {
                    offlineViewModel.error = nil
                }
                
            } message: {
                Text(offlineViewModel.error ?? "No message...")
            }
            
        }
    }
    
    
    private func resetIfNotInOvertime() {
        if !offlineViewModel.state.isInOvertime {
            offlineViewModel.resetOfflineTime()
        }
    }
    
}

#Preview {
    HomeView()
        .environment(OfflineViewModel())
        .environment(PermissionsViewModel())
        .environment(LiveActivityViewModel())
        .environment(OfflineCountViewModel())
}
