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
            Debug()
        }
    }
}



fileprivate struct AppEntry: View {
    @AppStorage("needsOnboarding") private var needsOnboarding = true
    
    var body: some View {
        VStack {
            HomeView()
                .fullScreenCover(isPresented: $needsOnboarding) {
                    OnboardingView()
                }
        }
    }
}


fileprivate struct Debug: View {
    
    @State private var onboardingViewModel = OnboardingViewModel()
    
    
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
        .environment(OfflineViewModel())
    }
}
