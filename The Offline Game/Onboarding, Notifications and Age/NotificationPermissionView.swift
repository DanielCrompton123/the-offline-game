//
//  NotificationPermissionView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import UserNotifications


struct NotificationPermissionView: View {
    @Environment(OnboardingViewModel.self) private var onboardingViewModel
    
    var body: some View {

        VStack {
            Spacer()
            
            OfflineHeader()
            
            Spacer()
                        
            if let notificationStatus = onboardingViewModel.notificationStatus {
                description(for: notificationStatus)
                
                Spacer()
                
                buttons(for: notificationStatus)
            }
            
            else {
                ProgressView("Loading notification status")
            }
        }
        
        // Load the notification status when the UI appears with high priority
        .task(priority: .high) {
            await onboardingViewModel.loadNotificationStatus()
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
            Button("GET PERMISSION", action: onboardingViewModel.requestNotificationPermission)
        }
        
        // NOTIS ALLOWED: JUST CLOSE
        else if status == .denied {
            Button("CONTINUE WITHOUT", action: endOnboarding)
            
            Button("OPEN IN SETTINGS",
                   action: onboardingViewModel.openNotificationSettings)
        }
        
        // NOTIS DENIES: TELL THEM TO OPEN SETTINGS OR CONTINUE WITHOUT
        else if status == .authorized {
            Button("CLOSE", action: endOnboarding)
        }
    }


    private func endOnboarding() {
        onboardingViewModel.hasSeenOnboarding = true
    }
}

#Preview {
    NotificationPermissionView()
        .environment(OnboardingViewModel())
}
