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
    @Environment(NotificationPermissionsViewModel.self) private var permissionsViewModel
    @Environment(AppBlockerViewModel.self) private var appBlockerViewModel
    @Environment(LiveActivityViewModel.self) private var liveActivityViewModel
    @Environment(OfflineCountViewModel.self) private var offlineCountViewModel
    @Environment(GameKitViewModel.self) private var gameKitViewModel

    // If the user has disabled notifications in settings behind our backs (while the app was closed), check if they are now denied and warn them if so.
    @State private var shouldShowNotificationWarning = false
    
    // Also one for the app blocker permissions warning
    @State private var shouldShowAppBlockerWarning = false
    
    // Show or hide settings view
    @State private var settingsIsOpen = false
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        @Bindable var offlineCountViewModel = offlineCountViewModel
        
        NavigationStack {
            
            // CONTENT
            
            VStack {
                
                Spacer(minLength: 0)
                
                OfflineHeader()
                
                Spacer(minLength: 0)
                
                Text("\(Text(String(offlineCountViewModel.count)).foregroundStyle(.ruby)) people are offline right now, competing to see who can avoid their phone the longest.\n\(Text("Up for the challenge?").foregroundStyle(colorScheme == .light ? .black : .white))")
                    .textCase(.uppercase)
                    .contentTransition(.numericText(countsDown: true))
                    .font(.main20)
                    .foregroundStyle(.smog)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                Button {
                     offlineViewModel.isPickingDuration = true
                } label: {
                    Text("GO OFFLINE")
                        .minimumScaleFactor(0.2)
                        .font(.main30)
                        .padding(8)
                }
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
                
                Spacer(minLength: 0)
                
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
            
            // APP BLOCKER PERMISSION WARNING
            .fullScreenCover(
                isPresented: $shouldShowAppBlockerWarning,
                onDismiss: gameKitViewModel.openAccessPoint
            ) {
                FamilyControlsPermissionView()
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
            
            // LOAD FAMILY CONTROLS STATUS
            .onChange(of: appBlockerViewModel.status) { old, new in
                // IF the user tuned off family controls for the app then tell them to turn it on again
                
                shouldShowAppBlockerWarning = new != .approved
            }
            
            // SETTINGS BUTTON
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") {
                        settingsIsOpen = true
                    }
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
        .environment(NotificationPermissionsViewModel())
        .environment(LiveActivityViewModel())
        .environment(OfflineCountViewModel())
        .environment(GameKitViewModel())
}
