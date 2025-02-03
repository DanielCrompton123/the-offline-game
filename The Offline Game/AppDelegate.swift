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
        print("offlineViewModel?.isOffline == true = \(offlineViewModel?.state.isOffline == true)")
        guard offlineViewModel?.state.isOffline == true else { return }
        
        // When the app terminates, tell the user that their offline time has ended
        offlineViewModel?.offlineTimeFinished(successfully: false)
        print("Offline time finished NOT successfully")
        
        #warning("`OfflineNotification.appTerminated.post()` -- notification never posted")
        OfflineNotification.appTerminated.post()
    }
    
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("Protected data available")
    
        protectedDataWillBecomeUnavailable = false
        
        // Only do this if we are offline
        guard offlineViewModel?.state.isOffline == true else { return }
        print("The user is offline")
        
        // When the phone turns on, we need to ensure our app is in the foreground, but give the user 5 seconds to open the app before starting their grace period
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5
        ) { [weak self] in
            print("Waited 5s for the user to open the app and protectedDataWillBecomeUnavailable = \(self?.protectedDataWillBecomeUnavailable ?? false) and applicationState = \(UIApplication.shared.applicationState)")
            if UIApplication.shared.applicationState != .active,
               self?.protectedDataWillBecomeUnavailable == false {
                self?.offlineTracker?.startGracePeriod()
            }
        }
        
        // ^^^^^
        // Start when the protected data becomes available and end when it becomes unavailable
        // -Make sure the protected data will become available property is still false in the async After, befoe starting the grace period. IN THOSE 5 SECONDS THE APP HAS CLOSED AGAIN AND THE CONDITION `UIApplication.shared.applicationState != .active` IS FALSE SO THE GRACE PERIOD STARTS

    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        // When the phone turns off, that's great, because we are definitely offline!
        print("Protected data unavailable")
        protectedDataWillBecomeUnavailable = true
    }
}
