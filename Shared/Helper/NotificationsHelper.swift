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
    
    
    static var notificationIDs = [String]()
    
    
    static func post(title: String,
                     message: String,
                     id: String = UUID().uuidString,
                     trigger: UNNotificationTrigger?) {
        Task {
            // Create notification
            let notification = UNMutableNotificationContent()
            notification.title = title
            notification.body = message
            notification.interruptionLevel = .critical
            
            // Create request
            notificationIDs.append(id)
            let request = UNNotificationRequest(identifier: id, content: notification, trigger: trigger)
            
            do {
                // Post request
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("Error posting notification \(error)")
            }
        }
    }
    
    
    static func post(title: String,
                     message: String,
                     id: String = UUID().uuidString,
                     at dateComponents: DateComponents) {
        
        Task {
            var dateComponents = dateComponents
            dateComponents.calendar = .current
            
            // Create trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            post(title: title, message: message, id: id, trigger: trigger)
            
        }
    }
    
    
    static func post(title: String,
                     message: String,
                     id: String = UUID().uuidString,
                     at date: Date) {
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        post(title: title, message: message, id: id, at: dateComponents)
        
    }
    
    
    static func post(title: String,
                     message: String,
                     id: String = UUID().uuidString,
                     timeInterval: TimeInterval,
                     repeating: Bool = false) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeating)
        
        post(title: title, message: message, id: id, trigger: trigger)
    }
    
    
    static func revoke(notification id: String) {
        guard let index = notificationIDs.firstIndex(of: id) else { return }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        notificationIDs.remove(at: index)
    }
    
}
