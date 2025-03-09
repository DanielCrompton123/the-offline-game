//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import FirebaseCore
import Combine
import WishKit


@main
struct The_Offline_GameApp: App {
    
    // Assign an app delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            IS_DEBUG ? AnyView(DEBUG()) : AnyView(ENTRY())
        }
    }
}



fileprivate struct ENTRY: View {
    
    // Get the scene phase
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) var shouldShowOnboarding = true
    
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = NotificationPermissionsViewModel()
    @State private var appBlockerViewModel = AppBlockerViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var offlineCountViewModel = OfflineCountViewModel()

    @State private var gameKitViewModel = GameKitViewModel()
    @State private var gameKitAchievementsViewModel = GameKitAchievementsViewModel()
    @State private var gameKitLeaderboardViewModel = GameKitLeaderboardViewModel()
    
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
        
        // CONNECTIONS AND SETUP
            .onAppear {
                makeConnections()
                
                setupGameCenter()
                setupWishKit()
                setupFirebase()
            }
        
            // When the gameCenter enabled changes to true, this means the setupGameCenter() authentication handler will have worked.
            // Now we know we are signed in we can load the achievements
            .onChange(of: gameKitViewModel.gameCenterEnabled, { oldValue, newValue in

                if newValue == true {
                    Task {
                        // Load the achievements
                        await gameKitViewModel.achievementsViewModel?.loadAchievements()
                        
                        // Record progress for the 2/7DaysRunning achievements
                        await OfflineAchievementsProgressManager.shared.handle(
                            event: .appOpened,
                            achievementViewModel: gameKitAchievementsViewModel
                        )
                    }
                    
                    // While the other task is running, do ANOTHER TASK at the same time, that loads the leaderboards
                    Task {
                        await gameKitLeaderboardViewModel.loadLeaderboards()
                        // That also loads the scores
                    }
                }
            })
        
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
            .environment(appBlockerViewModel)
        
    }
    
    
    private func makeConnections() {
        // Live activity VM
        liveActivityViewModel.offlineViewModel = offlineViewModel
//        liveActivityViewModel.offlineCountViewModel = offlineCountViewModel
        offlineViewModel.liveActivityViewModel = liveActivityViewModel
        
        offlineViewModel.offlineCountViewModel = offlineCountViewModel
        
        // App delegate
        appDelegate.offlineViewModel = offlineViewModel
        
        // GameKit VMs
        gameKitViewModel.offlineViewModel = offlineViewModel
        gameKitViewModel.achievementsViewModel = gameKitAchievementsViewModel
        gameKitViewModel.leaderboardViewModel = gameKitLeaderboardViewModel
        gameKitLeaderboardViewModel.gameKitViewModel = gameKitViewModel
        offlineViewModel.gameKitViewModel = gameKitViewModel
        
        // Tracker
        OfflineTracker.shared.offlineViewModel = offlineViewModel
        OfflineTracker.shared.appDelegate = appDelegate
    }
    
    
    private func setupFirebase() {
        
        FirebaseApp.configure()
        
        offlineCountViewModel.loadDatabase()
        offlineCountViewModel.setupDatabaseObserver()

    }
    
    
    private func setupGameCenter() {
        // Only open the access point if we should not present the onboarding screen straight away
        if !shouldShowOnboarding {
            gameKitViewModel.authenticatePlayer()
            gameKitViewModel.openAccessPoint()
        }
        
    }
    
    
    private func setupWishKit() {
        WishKit.configure(with: K.wishKitAPIKey)
        
    }
}
