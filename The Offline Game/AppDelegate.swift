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
    
    var protectedDataWillBecomeUnavailable = false
            
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate")
        
        OfflineTracker.shared.appTerminated()
    }
    
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("Protected data available")
    
        protectedDataWillBecomeUnavailable = false
        
        OfflineTracker.shared.protectedDataDidBecomeAvailable()
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        // When the phone turns off, that's great, because we are definitely offline!
        print("Protected data unavailable")
        protectedDataWillBecomeUnavailable = true
    }
}
