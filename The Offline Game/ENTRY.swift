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
    
    @State private var backgroundTimer: Timer?
    @State private var backgroundTimerTaskId: UIBackgroundTaskIdentifier?
    
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var offlineCountViewModel = OfflineCountViewModel()
    
    // Store a unique user ID
    @AppStorage(K.userDefaultsUserIdKey) private var userId = UUID().uuidString
    
    @Environment(AppDelegate.self) private var appDelegate
    
    var body: some View {
        
        HomeView()
        
        // ONBOARDING
            .fullScreenCover(isPresented: $shouldShowOnboarding) {
                OnboardingView()
            }
        
            .onAppear(perform: makeConnections)
            .onAppear(perform: setupFirebase)
            .onChange(of: scenePhase) { old, new in
                scenePhaseChanged(from: old, to: new)
            }
        
        // ENVIRONMENT
            .environment(offlineViewModel)
            .environment(permissionsViewModel)
            .environment(liveActivityViewModel)
            .environment(activityViewModel)
            .environment(offlineCountViewModel)
        
    }
    
    
    private func makeConnections() {
        liveActivityViewModel.offlineViewModel = offlineViewModel
        liveActivityViewModel.offlineCountViewModel = offlineCountViewModel
        offlineViewModel.liveActivityViewModel = liveActivityViewModel
        offlineViewModel.offlineCountViewModel = offlineCountViewModel
        appDelegate.offlineViewModel = offlineViewModel
        OfflineTracker.shared.offlineViewModel = offlineViewModel
    }
    
    
    private func setupFirebase() {
        FirebaseApp.configure()
        
        offlineCountViewModel.loadDatabase()
        offlineCountViewModel.setupDatabaseObserver()
    }
    
    
    private func scenePhaseChanged(from oldValue: ScenePhase, to newValue: ScenePhase) {
        // Only do this if we are offline
        guard offlineViewModel.state.isOffline else { return }
        
        
        if newValue == .background {
            print("App went into background")
            // If the app went into background because the phone turned off do nothing
            // If the phone was turned on though (the user switched to another app maybe) offer them grace period
            
            // We need to use a background task here so that the timer can run in the background
            backgroundTimerTaskId = UIApplication.shared.beginBackgroundTask()
            
            backgroundTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                print("1.5 seconds passed. Protected data will become unavailable = \(appDelegate.protectedDataWillBecomeUnavailable)")
                
                // End BG task
                if let backgroundTimerTaskId {
                    UIApplication.shared.endBackgroundTask(backgroundTimerTaskId)
                }

                // If protected data WILL become unavailable, that's great, stay offline.
                // Otherwise, the app will have been put into background because the user closed it.
                // So we should start a grace period
                if !appDelegate.protectedDataWillBecomeUnavailable {
                    OfflineTracker.shared.startGracePeriod()
                }
            }
                        
        } else {
            print("App went into foreground/inactive")
            backgroundTimer?.invalidate()
            backgroundTimer = nil
            
            // Still make sure any background tasks are terminated (if they weren't in a second)
            if let backgroundTimerTaskId {
                UIApplication.shared.endBackgroundTask(backgroundTimerTaskId)
            }
            
            // When the app goes active or inactive, (foreground) end the grace period successfully, but only if a grace period was started.
            
            OfflineTracker.shared.endGracePeriod(successfully: true)
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
