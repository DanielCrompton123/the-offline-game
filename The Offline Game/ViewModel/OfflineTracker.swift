//
//  OfflineGracePeriodHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/6/25.
//

import UIKit


@Observable
class OfflineTracker {
    
    var offlineViewModel: OfflineViewModel?
    var gracePeriodRunning = false
    
    private var gracePeriodTimer: Timer?
    private var backgroundTaskId: UIBackgroundTaskIdentifier?
    
    
    func startGracePeriod() {
        // Send the user a notification telling the user their grace period has started, and to open the app in XX minutes/seconds
        OfflineNotification.gracePeriodStarted.post()
        
        print("Grace period starting")
        
        // Now set the gracePeriodRunning to true
        gracePeriodRunning = true
        
        // Pause the user's offline time:
        // - this cancels the success notification among others
        offlineViewModel?.pauseOfflineTime()
        print("Paused offline time")
        
        // Now start the timer (20s)
        // also start a background task so it can keep running in the background
        backgroundTaskId = UIApplication.shared.beginBackgroundTask { [weak self] in
            DispatchQueue.main.async {
                // Expiration handler
                // When the BG task expires, (shouldn't do) just end the offline time
                self?.gracePeriodEnded(successfully: false)
                print("BG task expiration handler called")
            }
        }
        
        let startDate = Date()
        
        gracePeriodTimer = Timer.scheduledTimer(withTimeInterval: K.offlineGracePeriod,
                                                repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                print("grace period timer triggered")
                // When the offline time ends, send another notification
                self?.gracePeriodEnded(successfully: false)
                
                let endDate = Date()
                print("Grace period lasted \(startDate.distance(to: endDate).formatted())")
            }
        }
    }
    
    
    func gracePeriodEnded(successfully: Bool) {
        // Can only be ended if in grace period
        guard gracePeriodRunning else {
            return
        }
        
        print("Ending grace period successfully?\(successfully)")
        
        // If the user did not finish successfully, (and the app is still open) tell them
        if !successfully {
            OfflineNotification.gracePeriodEndedNotSuccessfully.post()
            
            // Also end offline time
            offlineViewModel?.offlineTimeFinished(successfully: false)
        } else {
            // If the user successfully opened the app in the grace period, resume the offline time where it left off when the app closed
            offlineViewModel?.resumeOfflineTime()
        }
        
        gracePeriodRunning = false
        gracePeriodTimer?.invalidate()
        gracePeriodTimer = nil
        
        // Now make sure to end the background task here too
        if let backgroundTaskId {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }
    
    
    func scheduleOfflineReminder() {
        // Schedule a notification to be sent tomorrow
        // At the same time as they went offline today
        
        #if DEBUG
        // When debugging, don't wait until tommorrow -- wait 30 seconds then post the reminder notification
        guard
            let endDate = offlineViewModel?.endDate,
            let tomorrow = Calendar.current.date(byAdding: DateComponents(second: 15), to: endDate)
        else {
            print("End date is nil")
            return
        }
        #else
        guard
            let startDate = offlineViewModel?.oldStartDate,
            let tomorrow = Calendar.current.date(byAdding: DateComponents(day: 1), to: startDate)
        else {
            print("Start date is nil")
            return
        }
        #endif
        
        print("Will post reminder at \(tomorrow)")
        
        OfflineNotification.offlineReminder(tomorrow: tomorrow).post()
    }
    
    
    func revokeOfflineReminder() {
        NotificationsHelper.revoke(notification: K.offlineReminderNotificationId)
    }
}
