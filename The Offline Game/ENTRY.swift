//
//  The_Offline_GameApp.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    
    var offlineViewModel: OfflineViewModel?
            
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate")
        
        // Only do this if we are offline
        guard offlineViewModel?.isOffline == true else { return }
        
        // When the app terminates, tell the user that their offline time has ended
        offlineViewModel?.offlineTimeFinished(successfully: false)
        
        OfflineTracker.shared.sendTerminationNotification()
    }
    
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("Protected data available")
        
        // Only do this if we are offline
        guard offlineViewModel?.isOffline == true else { return }
        
        // When the phone turns on, we need to ensure our app is in the foreground, but give the user 5 seconds to open the app before starting their grace period
        DispatchQueue.main.asyncAfter(deadline: .now() + K.offlineGracePeriodDelaySinceProtectedDataAvailability) {
            if UIApplication.shared.applicationState != .active {
                OfflineTracker.shared.startGracePeriod()
            }
        }
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        // When the phone turns off, that's great, because we are definitely offline!
        print("Protected data unavailable")
    }
}


@main
struct The_Offline_GameApp: App {
    
    // Assign an app delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    // Get the scene phase
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) var shouldShowOnboarding = true
    
    @State private var offlineViewModel = OfflineViewModel()
    @State private var permissionsViewModel = PermissionsViewModel()
    @State private var liveActivityViewModel = LiveActivityViewModel()
    @State private var activityViewModel = ActivityViewModel()
    @State private var offlineCountViewModel = OfflineCountViewModel()
    
    // Store a unique user ID
    @AppStorage(K.userDefaultsUserIdKey) private var userId = UUID().uuidString
    
    
    var body: some Scene {
        WindowGroup {
            
            HomeView()
                .fullScreenCover(isPresented: $shouldShowOnboarding) {
                    OnboardingView()
                }
                .onAppear {
                    liveActivityViewModel.offlineViewModel = offlineViewModel
                    offlineViewModel.liveActivityViewModel = liveActivityViewModel
                    offlineViewModel.offlineCountViewModel = offlineCountViewModel
                    
                    appDelegate.offlineViewModel = offlineViewModel
                    OfflineTracker.shared.offlineViewModel = offlineViewModel
                    
                    FirebaseApp.configure()
                    
                    offlineCountViewModel.loadDatabase()
                    offlineCountViewModel.setupDatabaseObserver()
                }
                .environment(offlineViewModel)
                .environment(permissionsViewModel)
                .environment(liveActivityViewModel)
                .environment(activityViewModel)
                .environment(offlineCountViewModel)
                .onChange(of: scenePhase) { oldValue, newValue in
                    // Only do this if we are offline
                    guard offlineViewModel.isOffline else { return }
                    
                    if newValue == .background {
                        // If the app went into background because the phone turned off do nothing
                        // If the phone was turned on though (the user switched to another app maybe_ offer them grace period
                        
                        if UIApplication.shared.isProtectedDataAvailable {
                            OfflineTracker.shared.startGracePeriod()
                        }
                        
                    } else {
                        
                        // When the app goes active or inactive, (foreground) end the grace period successfully, but only if a grace period was started.
                        if OfflineTracker.shared.gracePeriodRunning {
                            OfflineTracker.shared.gracePeriodEnded(successfully: true)
                        }
                    }
                }
            
        }
    }
}
