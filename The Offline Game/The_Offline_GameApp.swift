//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

@main
struct The_Offline_GameApp: App {
    @AppStorage("needsOnboarding") private var needsOnboarding = true
        
    var body: some Scene {
        WindowGroup {
            VStack {
                HomeView()
                    .fullScreenCover(isPresented: $needsOnboarding) {
                        OnboardingView()
                    }
            }
            .environment(UserAccountViewModel())
        }
    }
}
