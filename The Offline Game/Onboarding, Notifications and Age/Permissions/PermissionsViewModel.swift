//
//  PermissionsViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/3/24.
//

import UserNotifications
import SwiftUI


@Observable
class PermissionsViewModel {
    
        
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationSettingsURL = URL(string: UIApplication.openNotificationSettingsURLString)!
    
    var notificationStatus: UNAuthorizationStatus? = nil
    
    func loadNotificationStatus() async {
        notificationStatus = await notificationCenter.notificationSettings().authorizationStatus
    }
    
    func openNotificationSettings() {
        guard UIApplication.shared.canOpenURL(notificationSettingsURL) else { return }
        UIApplication.shared.open(notificationSettingsURL)
    }
    
    func requestNotificationPermission() {
        Task {
            do {
                let acceptedAlerts = try await notificationCenter.requestAuthorization(
                    options: [.alert, .badge, .sound]
                )
                
                notificationStatus = acceptedAlerts ? .authorized : .denied
                
            } catch {
                print("Error requesting notifications \(error)")
            }
        }
    }
    
}
