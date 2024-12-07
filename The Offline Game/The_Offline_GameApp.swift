//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

@main
struct The_Offline_GameApp: App {
    
    @State private var onboardingViewModel = OnboardingViewModel()
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    
    // Store a unique user ID
    @AppStorage("userID") private var userID = UUID().uuidString
    
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                HomeView()
                    .fullScreenCover(
                        isPresented: $onboardingViewModel.hasNotSeenOnboarding
                    ) {
                        OnboardingView()
                    }
            }
            .onAppear {
                liveActivityViewModel.offlineViewModel = offlineViewModel
                offlineViewModel.liveActivityViewModel = liveActivityViewModel
            }
            .environment(onboardingViewModel)
            .environment(offlineViewModel)
            .environment(permissionsViewModel)
            .environment(liveActivityViewModel)
            
        }
    }
}
