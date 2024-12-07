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
        
    // If the user has disabled notifications in settings behind our backs (while the app was closed), check if they are now denied and warn them if so.
    @State private var shouldShowNotificationWarning = false
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        NavigationStack {
            VStack {
                
                Spacer()
                
                OfflineHeader()
                
                Spacer()
                
                Text("\(Text("2,571").foregroundStyle(.ruby)) people are offline right now, competing to see who can avoid their phone the longest.\n\(Text("Up for the challenge?").foregroundStyle(colorScheme == .light ? .black : .white))")
                    .textCase(.uppercase)
                    .font(.main20)
                    .foregroundStyle(.smog)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button("GO OFFLINE") {
                    offlineViewModel.isPickingDuration = true
                }
                .buttonStyle(FilledRedButtonStyle())
                
                Spacer()
                
            }
            .sheet(isPresented: $offlineViewModel.isPickingDuration) {
                OfflineTimeView()
            }
            .sheet(isPresented: $offlineViewModel.userShouldBeCongratulated) {
                CongratulatoryView()
            }
            .fullScreenCover(isPresented: $shouldShowNotificationWarning) {
                NotificationPermissionView()
            }
            .fullScreenCover(isPresented: $offlineViewModel.isOffline) {
                OfflineView()
            }
            .task(priority: .high) {
                await permissionsViewModel.loadNotificationStatus()
                shouldShowNotificationWarning = permissionsViewModel.notificationStatus == .denied
            }
            
        }
    }

}

#Preview {
    HomeView()
        .environment(OnboardingViewModel())
        .environment(OfflineViewModel())
        .environment(PermissionsViewModel())
        .environment(LiveActivityViewModel())
}
