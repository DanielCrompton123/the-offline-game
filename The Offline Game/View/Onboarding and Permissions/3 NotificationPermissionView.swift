//
//  NotificationPermissionView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import UserNotifications


struct NotificationPermissionView: View {
    @Environment(PermissionsViewModel.self) private var permissionsViewModel
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) private var shouldShowOnboarding = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

        VStack {
            Spacer()
            
            OfflineHeader()
            
            Spacer()
                        
            if let notificationStatus = permissionsViewModel.notificationStatus {
                description(for: notificationStatus)
                
                Spacer()
                
                buttons(for: notificationStatus)
            }
            
            else {
                ProgressView("Loading focus status")
            }
        }
        
        // Load the notification status when the UI appears with high priority
        .task(priority: .high) {
            await permissionsViewModel.loadNotificationStatus()
        }
        .font(.main20)
        .multilineTextAlignment(.center)
        .textCase(.uppercase)
        .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
    }
    
    
    @ViewBuilder
    private func description(for status: UNAuthorizationStatus) -> some View {
        
        // IF NOTIFICATIONS ARE NOT ALLOWED OR DECLINED, ASK THEM
        if status == .notDetermined {
            Text("We need to send you notifications to help you track your offline time.\nWE STRONGLY RECOMMEND ENABLING NOTIFICATIONS.")
                .foregroundStyle(.accent)
        }
        
        // IF NOTIS DENIES, TELL THEM TO OPEN SETTINGS
        else if status == .denied {
            Text("You have denied notifications in the past. Open settings to continue")
                .foregroundStyle(.ruby)
        }
        
        // IF NOTIS AUTHORIZED, TELL THEM
        else if status == .authorized {
            Text("All good. You have authorized notifications")
                .foregroundStyle(.green)
        }
    }
    
    
    @ViewBuilder
    private func buttons(for status: UNAuthorizationStatus) -> some View {
        
        // NOTID NOT ASKED FOR: ASK PERMISSION
        if status == .notDetermined {
            Button("GET PERMISSION", action: permissionsViewModel.requestNotificationPermission)
        }
        
        // NOTIS ALLOWED: JUST CLOSE
        else if status == .denied {
            Button("CONTINUE WITHOUT", action: endOnboarding)
            
            Button("OPEN IN SETTINGS",
                   action: permissionsViewModel.openNotificationSettings)
        }
        
        // NOTIS DENIES: TELL THEM TO OPEN SETTINGS OR CONTINUE WITHOUT
        else if status == .authorized {
            Button("CLOSE", action: endOnboarding)
        }
    }


    private func endOnboarding() {
        shouldShowOnboarding = false
        
        // If the user turns off notifications when the app is closed, it opens by presenting the notification permission view as a warning.
        // Therefore in this case it is not in a navigation stack during onboarding, so this will not dismiss it.
        
        // Ensure it can still be dismissed
        dismiss()
    }
}

#Preview {
    NotificationPermissionView()
}
