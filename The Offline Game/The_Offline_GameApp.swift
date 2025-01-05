//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import FirebaseCore


@main
struct The_Offline_GameApp: App {
        
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) var shouldShowOnboarding = true

    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var offlineCountViewModel = OfflineCountViewModel()
    
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
                offlineViewModel.offlineCountViewModel = offlineCountViewModel
                                
                FirebaseApp.configure()
                
                offlineCountViewModel.loadDatabase()
                offlineCountViewModel.setupDatabaseObserver()
            }
            .environment(offlineViewModel)
            .environment(permissionsViewModel)
            .environment(liveActivityViewModel)
            .environment(activityViewModel)
            .environment(offlineCountViewModel)
            
        }
    }
}
