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
    
    private let gracePeriodHelper = GracePeriodHelper.shared
    
    
    func startGracePeriod() {
        
        gracePeriodHelper.startGracePeriod { [weak self] in
            
            // On start
            // When it started, pause offline time:
            
            // - this cancels the success notification among others
            self?.offlineViewModel?.pauseOfflineTime()
            
        } onEnd: { [weak self] successfully in
            
            // If it ended successfully, continue the offline time
            if successfully {
                self?.offlineViewModel?.resumeOfflineTime()
            }
            
            // if it was NOT succcessful, just end the offline time
            else {
                self?.offlineViewModel?.offlineTimeFinished(successfully: false)
            }
            
        }
        
    }
    
    
    func endGracePeriod(successfully: Bool) {
        gracePeriodHelper.endGracePeriod(successfully: successfully)
    }
    
    
    func scheduleOfflineReminder() {
        // Schedule a notification to be sent tomorrow
        // At the same time as they went offline today
        
        #if DEBUG
        // When debugging, don't wait until tommorrow -- wait 30 seconds then post the reminder notification
        guard
            let endDate = offlineViewModel?.state.endDate,
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
