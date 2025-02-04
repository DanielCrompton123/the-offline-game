//
//  OfflineNotifications.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/12/25.
//

import Foundation
import UserNotifications

struct OfflineNotification {
    
    //MARK: - Notification properties
    private let title: String
    private let message: String
    private let trigger: UNNotificationTrigger
    private let id: String
    
    //MARK: - Default notifications
    
    static let appTerminated = OfflineNotification(
        title: "Sorry, we ended your offline time...",
        message: "Please make sure you leave the app open when you go offline next time.",
        trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false),
        id: K.appTerminatedNotificationId
    )
    
    static let gracePeriodStarted = OfflineNotification(
        title: String(format: "Open the app in %.0f seconds...", K.offlineGracePeriod),
        message: "...to keep your offline time. We need to know you're not cheating and using other apps!",
        trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false),
        id: K.gracePeriodStartedNotificationId
    )
    
    static let gracePeriodEndedNotSuccessfully = OfflineNotification(
        title: "You've been online for too long",
        message: "Your offline time just ended, try again later & commit!",
        trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false),
        id: K.gracePeriodEndedNotSuccessfullyNotificationId
    )
    
    static func offlineReminder(tomorrow: Date) -> Self {
        OfflineNotification(
            title: "Don't forget to go offline today!",
            message: "We believe you can last out the whole offline period this time.",
            trigger: UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tomorrow),
                repeats: false
            ),
            id: K.offlineReminderNotificationId
        )
    }
    
    static func congratulatoryNotification(endDate: Date, formattedDuration: String) -> Self {
        OfflineNotification(
            title: "You won the Offline Game!",
            message: "You went offline for \(formattedDuration)! Open the app to review your experience.",
            trigger: UNCalendarNotificationTrigger(
                dateMatching: NotificationsHelper.dateComponents(from: endDate),
                repeats: false
            ),
            id: K.offlineDurationEndedNotificationId
        )
    }
    
    
    //MARK: - Posting and revoking
    
    func post() {
        NotificationsHelper.post(title: title,
                                 message: message,
                                 id: id,
                                 trigger: trigger)
    }
    
    func revoke() {
        NotificationsHelper.revoke(notification: id)
    }
}
