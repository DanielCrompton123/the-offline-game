//
//  GracePeriodHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/2/25.
//

import UIKit


class GracePeriodHelper {
    
    private init() { }
    
    static let shared = GracePeriodHelper()
    
    
    var gracePeriodRunning = false
    private var gracePeriodTimer: Timer?
    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
    private var onEnd: ((Bool) -> ())?
    
    
    // Helper function to start the offline grace period and do something before it starts, and once it finishes
    func startGracePeriod(onStart: (() -> ())? = nil,
                          onEnd: ((Bool) -> ())? = nil) {
        
        self.onEnd = onEnd
        
        // Send the user a notification telling the user their grace period has started, and to open the app in XX minutes/seconds
        OfflineNotification.gracePeriodStarted.post()
        
        print("Grace period starting")
        
        gracePeriodRunning = true
        
        onStart?()
        print("onStart called")
        
        // Now start the timer (20s)
        // also start a background task so it can keep running in the background
        backgroundTaskId = UIApplication.shared.beginBackgroundTask {
            DispatchQueue.main.async {
                // Expiration handler
                // When the BG task expires, call onEnded
                onEnd?(false)
                print("BG task expiration handler called")
            }
        }
        
        gracePeriodTimer = Timer.scheduledTimer(withTimeInterval: K.offlineGracePeriod,
                                                repeats: false) { [weak self] _ in
            
            // ON ENDED not successfully
            print("gracePeriodTimer triggered")
            self?.gracePeriodDidEnd(successfully: false)
        }
        
    }
    
    
    private func gracePeriodDidEnd(successfully: Bool) {
        
        print("gracePeriodDidEnd called, successfully=\(successfully)")
        
        if !successfully {
            // Post the notification
            OfflineNotification.gracePeriodEndedNotSuccessfully.post()
        }
        
        // call onEnd (set when the grace period is started)
        onEnd?(successfully)
        
        gracePeriodRunning = false
        
        // Now make sure to end the background task here too
        if let backgroundTaskId {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }
    
    
    func endGracePeriod(successfully: Bool) {
        
        // Ends the grace period by cancelling the timer and ending BG task
        guard gracePeriodRunning else { return }
        
        gracePeriodTimer?.invalidate()
        gracePeriodTimer = nil
        
        gracePeriodDidEnd(successfully: successfully)
    }
    
}
