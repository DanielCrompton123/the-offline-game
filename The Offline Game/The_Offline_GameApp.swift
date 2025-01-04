//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

@main
struct The_Offline_GameApp: App {
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) var shouldShowOnboarding = true

    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    
    // Store a unique user ID
    @AppStorage("userID") private var userID = UUID().uuidString
    
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                HomeView()
                    .fullScreenCover(
                        isPresented: $shouldShowOnboarding
                    ) {
                        OnboardingView()
                    }
            }
            .onAppear {
                liveActivityViewModel.offlineViewModel = offlineViewModel
                offlineViewModel.liveActivityViewModel = liveActivityViewModel
            }
            .environment(offlineViewModel)
            .environment(permissionsViewModel)
            .environment(liveActivityViewModel)
            .environment(activityViewModel)
            
        }
    }
}
