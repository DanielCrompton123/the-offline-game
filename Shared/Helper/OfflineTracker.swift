//
//  OfflineGracePeriodHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/6/25.
//

import UIKit


@Observable
class OfflineTracker {
    private init() { }
    
    static let shared = OfflineTracker()
    
    var offlineViewModel: OfflineViewModel?
    var gracePeriodRunning = false
    private var graceTimer: Timer?
    
    
    func startGracePeriod() {
        // Send the user a notification telling the user their grace period has started, and to open the app in XX minutes/seconds
        NotificationsHelper.post(
            title: String(format: "Open the app in %.0f seconds...", K.offlineGracePeriod),
            message: "...to keep your offline time. We need to know you're not cheating and using other apps!",
            timeInterval: 1
        )
        
        print("Tracker grace period starting. Posted notification")
        
        // Now set the gracePeriodRunning to true
        gracePeriodRunning = true
        print("gracePeriodRunning = \(gracePeriodRunning)")
        
        // Now start the timer (20s)
        // also start a background task so it can keep running in the background
        let bgTaskId = UIApplication.shared.beginBackgroundTask()
        
        let startDate = Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + /*K.offlineGracePeriod*/ 20) { [weak self] in
            // When the offline time ends, send another notification
            self?.gracePeriodEnded(successfully: false)
            
            let endDate = Date()
            print("Grace period lasted \(startDate.distance(to: endDate))")
            
            // Now end the background task
            UIApplication.shared.endBackgroundTask(bgTaskId)
        }
    }
    
    
    func gracePeriodEnded(successfully: Bool) {
        print("gracePeriodEnded: gracePeriodRunning = \(gracePeriodRunning)")
        // Can only be ended if in grace period
        guard gracePeriodRunning else {
            print("grace period = \(gracePeriodRunning) which is false")
            return
        }
        
        print("Ending grace period successfully?\(successfully)")
        
        // If the user did not finish successfully, (and the app is still open) tell them
        if !successfully {
            NotificationsHelper.post(
                title: "You've been online for too long",
                message: "Your offline time just ended, try again later & commit!",
//                trigger: nil
                timeInterval: 1
            )
            print("Posted failure notification")
            
            // Also end offline time
            offlineViewModel?.offlineTimeFinished(successfully: false)
        }
        
        graceTimer = nil
        gracePeriodRunning = false
    }
    
    
    func sendTerminationNotification() {
        NotificationsHelper.post(
            title: "We ended offline time...",
            message: "Please make sure you leave the app open when you go offline next time.",
//            trigger: nil
            timeInterval: 1
        )
    }
}
