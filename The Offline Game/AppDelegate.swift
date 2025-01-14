//
//  AppDelegate.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/12/25.
//

import UIKit

@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var offlineViewModel: OfflineViewModel?
    var offlineTracker: OfflineTracker?
    
    var protectedDataWillBecomeUnavailable = false
            
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate")
        
        // Only do this if we are offline
        // offlineViewModel?.isOffline == true = false
        // because it's been destroyed?
        print("offlineViewModel == nil = \(offlineViewModel == nil)")
        print("offlineViewModel?.isOffline == true = \(offlineViewModel?.isOffline == true)")
        guard offlineViewModel?.isOffline == true else { return }
        
        // When the app terminates, tell the user that their offline time has ended
        offlineViewModel?.offlineTimeFinished(successfully: false)
        print("Offline time finished NOT successfully")
        
        #warning("`OfflineNotification.appTerminated.post()` -- notification never posted")
        OfflineNotification.appTerminated.post()
    }
    
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("Protected data available")
    
        protectedDataWillBecomeUnavailable = false
        
        print("offlineViewModel?.isOffline == true = \(offlineViewModel?.isOffline == true)")
        // Only do this if we are offline
        guard offlineViewModel?.isOffline == true else { return }
        
        // When the phone turns on, we need to ensure our app is in the foreground, but give the user 5 seconds to open the app before starting their grace period
        DispatchQueue.main.asyncAfter(
            deadline: .now() + K.offlineGracePeriodDelaySinceProtectedDataAvailability
        ) { [weak self] in
            if UIApplication.shared.applicationState != .active {
                self?.offlineTracker?.startGracePeriod()
            }
        }
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        // When the phone turns off, that's great, because we are definitely offline!
        print("Protected data unavailable")
        protectedDataWillBecomeUnavailable = true
    }
}
