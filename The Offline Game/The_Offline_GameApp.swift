//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

@main
struct The_Offline_GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppEntry()
        }
    }
}



fileprivate struct AppEntry: View {
    @State private var onboardingViewModel = OnboardingViewModel()
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    
    // Store a unique user ID
    @AppStorage("userID") private var userID = UUID().uuidString
    
    var body: some View {
        VStack {
            HomeView()
                .fullScreenCover(
                    isPresented: $onboardingViewModel.hasNotSeenOnboarding
                ) {
                    OnboardingView()
                }
        }
        .environment(onboardingViewModel)
        .environment(offlineViewModel)
        .environment(permissionsViewModel)
    }
}
