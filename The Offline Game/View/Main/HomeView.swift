//
//  HomeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import ActivityKit


struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @Environment(PermissionsViewModel.self) private var permissionsViewModel
    @Environment(LiveActivityViewModel.self) private var liveActivityViewModel
    @Environment(OfflineCountViewModel.self) private var offlineCountViewModel
        
    // If the user has disabled notifications in settings behind our backs (while the app was closed), check if they are now denied and warn them if so.
    @State private var shouldShowNotificationWarning = false
    
    // Show or hide settings view
    @State private var settingsIsOpen = false
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        NavigationStack {
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
            .sheet(isPresented: $offlineViewModel.isPickingDuration) {
                OfflineDurationPickerView()
            }
            .sheet(isPresented: $offlineViewModel.userShouldBeCongratulated) {
                CongratulatoryView()
            }
            .sheet(isPresented: $offlineViewModel.userDidFail) {
                FailureView()
            }
            .sheet(isPresented: $settingsIsOpen) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $shouldShowNotificationWarning) {
                NotificationPermissionView()
            }
            .fullScreenCover(isPresented: $offlineViewModel.state.isOffline) {
                OfflineView()
            }
            .task(priority: .high) {
                await permissionsViewModel.loadNotificationStatus()
                await MainActor.run {
                    shouldShowNotificationWarning = permissionsViewModel.notificationStatus == .denied
                }
            }
            
            // Add the settings button to top leading
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
                    .font(.main16)
                    .tint(.smog)
                }
            }
            
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
