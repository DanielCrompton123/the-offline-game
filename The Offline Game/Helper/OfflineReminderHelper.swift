//
//  OfflineReminderHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/4/25.
//

import Foundation


struct OfflineReminderHelper {
    
    private init() { }
    
    
    static func scheduleReminderForTomorrow(today: Date) {
        
        // Get date components
        // Add 1 day to the date components in real app, but for testing purposes, just add 1 minute
        #if DEBUG
            let dateComponents = DateComponents(minute: 1)
        #else
            let dateComponents = DateComponents(day: 1)
        #endif
        
        // Now add the date
        guard let tomorrow = Calendar.current.date(byAdding: dateComponents, to: today) else {
            print("OfflineReminderHelper - Could not get tomorrow from date \(today)")
            return
        }
        
        OfflineNotification.offlineReminder(tomorrow: tomorrow).post()
        
    }
    
    
    static func revokeOfflineReminder() {
        NotificationsHelper.revoke(notification: K.offlineReminderNotificationId)
    }
    
}
