//
//  NotificationPermissionView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import UserNotifications


struct NotificationPermissionView: View {
    private let center = UNUserNotificationCenter.current()
    private let settingsURL = URL(string: UIApplication.openSettingsURLString)!
    
    @State private var notificationStatus: UNAuthorizationStatus? = nil
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {

        VStack {
            // IF USER HASN'T ACCEPTED / DECLINED, ASK THEM
            
            if let notificationStatus {
                
                if notificationStatus == .notDetermined {
                    
                    Text("We need to send you notifications to help you track your offline time.\nWE STRONGLY RECOMMEND ENABLING NOTIFICATIONS.")
                        .foregroundStyle(.accent)
                    
                    Spacer()
                    
                    Button("GET PERMISSION", action: getPermission)
                    
                }
                
                // IF USER HAS ACCEPTED:
                else if notificationStatus == .authorized {
                    Text("All good. You have authorized notifications")
                        .foregroundStyle(.green)
                    
                    Spacer()
                    
                    Button("CLOSE") {
                        dismiss()
                    }
                }
                
                // IF USER DENIED
                else if notificationStatus == .denied {
                    Text("You have denied notifications in the past. Open settings to continue")
                        .foregroundStyle(.ruby)
                    
                    Spacer()
                    
                    Button("CONTINUE WITHOUT") {
                        dismiss()
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        Button("OPEN IN SETTINGS") {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                }
                
            }
        }
        .task {
            notificationStatus = await center.notificationSettings().authorizationStatus
        }
        .font(.main20)
        .multilineTextAlignment(.center)
        .textCase(.uppercase)
        .buttonStyle(FilledRedButtonStyle())
    }
    
    
    func getPermission() {
        Task {
            do {
                let acceptedAlerts = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                guard acceptedAlerts else {
                    print("center.notificationSettings().authorizationStatus = \(await center.notificationSettings().authorizationStatus)")
                    print("acceptedResults = false -- see NotificationsViewModel")
                    return
                }
                
                notificationStatus = await center.notificationSettings().authorizationStatus
                
            } catch {
                print("Error requesting notifications \(error)")
            }
        }
    }


}

#Preview {
    NotificationPermissionView()
}
