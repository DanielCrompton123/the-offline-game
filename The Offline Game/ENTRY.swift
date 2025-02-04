//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import FirebaseCore
import Combine


@main
struct The_Offline_GameApp: App {
    
    // Assign an app delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ENTRY()
//            DEBUG()
        }
    }
}



fileprivate struct ENTRY: View {
    
    // Get the scene phase
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) var shouldShowOnboarding = true
    
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var offlineCountViewModel = OfflineCountViewModel()
    @State private var gameKitViewModel = GameKitViewModel()
    @State private var gameKitAchievementsViewModel = GameKitAchievementsViewModel()
    
    // Store a unique user ID
    @AppStorage(K.userDefaultsUserIdKey) private var userId = UUID().uuidString
    
    @Environment(AppDelegate.self) private var appDelegate
    
    var body: some View {
        
        HomeView()
        
        // ONBOARDING
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView()
                    .onDisappear(perform: setupGameCenter)
            }
        
        // CONNECTIONS AND GAME CENTER
            .onAppear {
                makeConnections()
                setupGameCenter()
            }
            .onAppear(perform: setupFirebase)
        
        // SCENE PHASE CHANGED
            .onChange(of: scenePhase) { _, new in
                OfflineTracker.shared.scenePhaseChanged(to: new)
            }
        
        // ENVIRONMENT
            .environment(offlineViewModel)
            .environment(permissionsViewModel)
            .environment(liveActivityViewModel)
            .environment(activityViewModel)
            .environment(offlineCountViewModel)
            .environment(gameKitViewModel)
        
    }
    
    
    private func makeConnections() {
        liveActivityViewModel.offlineViewModel = offlineViewModel
        liveActivityViewModel.offlineCountViewModel = offlineCountViewModel
        offlineViewModel.liveActivityViewModel = liveActivityViewModel
        offlineViewModel.offlineCountViewModel = offlineCountViewModel
        appDelegate.offlineViewModel = offlineViewModel
        gameKitViewModel.offlineViewModel = offlineViewModel
        gameKitViewModel.achievementsViewModel = gameKitAchievementsViewModel
        offlineViewModel.gameKitViewModel = gameKitViewModel
        
        OfflineTracker.shared.offlineViewModel = offlineViewModel
        OfflineTracker.shared.appDelegate = appDelegate
    }
    
    
    private func setupFirebase() {
        
        FirebaseApp.configure()
        
        offlineCountViewModel.loadDatabase()
        offlineCountViewModel.setupDatabaseObserver()
    }
    
    
    private func setupGameCenter()  {
        // Only open the access point if we should not present the onboarding screen straight away
        if !shouldShowOnboarding {
            gameKitViewModel.authenticatePlayer()
            gameKitViewModel.openAccessPoint()
            
            // Now also load the achievements
            gameKitViewModel.achievementsViewModel?.loadAchievements()
        }
        
    }
}



fileprivate struct DEBUG: View {
    var body: some View {
        Text("Hello")
            .delay(time: .now() + 2) {
                print("Delay")
            }
    }
}
