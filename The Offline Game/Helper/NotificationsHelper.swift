//
//  NotificationsHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/5/24.
//

import Foundation
import UserNotifications


struct NotificationsHelper {
    private init() { }
    
    static func post(title: String,
                     message: String,
                     id: String = UUID().uuidString,
                     trigger: UNNotificationTrigger?,
                     interruptionLevel: UNNotificationInterruptionLevel = .active) {
        Task {
            // Create notification
            let notification = UNMutableNotificationContent()
            notification.title = title
            notification.body = message
            notification.interruptionLevel = interruptionLevel
            
            // Create request
            let request = UNNotificationRequest(identifier: id, content: notification, trigger: trigger)
            
            do {
                // Post request
                try await UNUserNotificationCenter.current().add(request)
                print("Posted notification '\(title)'")
            } catch {
                print("Error posting notification \(error)")
            }
        }
    }
    
    
    static func revoke(notification id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    
    static func dateComponents(from date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
    
}
