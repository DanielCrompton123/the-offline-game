//
//  NotificationPermissionView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import UserNotifications


struct NotificationPermissionView: View {
    @Environment(NotificationPermissionsViewModel.self) private var permissionsViewModel
    @State private var showsAppBlockerPermission = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {

        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                Image(.bellWithSwoosh)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .scaleEffect(1.3)
                    .foregroundStyle(.smog)
                    .opacity(colorScheme == .light ? 0.1 : 0.4) // it's too hard to see the symbol in dark mode at 0.1
                    .rotationEffect(.degrees(7))
                
                Text("NOTIFICATIONS")
                    .font(.display88)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal)
            }
            
            Spacer()
            
                if let notificationStatus = permissionsViewModel.notificationStatus {
                    description(for: notificationStatus)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    buttons(for: notificationStatus)
                }
                
                else {
                    ProgressView("Loading notification status")
                }
        }
        
        // Load the notification status when the UI appears with high priority
        .task(priority: .high) {
            await permissionsViewModel.loadNotificationStatus()
        }
        .font(.main20)
        .multilineTextAlignment(.center)
        .textCase(.uppercase)
        .navigationDestination(isPresented: $showsAppBlockerPermission) {
            FamilyControlsPermissionView()
        }
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
        
        // NOTIFICATIONS NOT ASKED FOR: ASK PERMISSION
        if status == .notDetermined {
            Button("GET PERMISSION",
                   systemImage: "person.badge.shield.exclamationmark",
                   action: permissionsViewModel.requestNotificationPermission)
            .buttonStyle(FilledRedButtonStyle())
        }
        
        // NOTIFICATIONS ALLOWED: JUST CLOSE
        else if status == .denied {
            Button("CONTINUE WITHOUT",
                   systemImage: "exclamationmark.shield.fill",
                   action: nextStage)
            .buttonStyle(RedButtonStyle())
            
            Button("OPEN IN SETTINGS",
                   systemImage: "gear",
                   action: permissionsViewModel.openNotificationSettings)
            .buttonStyle(FilledRedButtonStyle())
        }
        
        // NOTIFICATIONS DENIED: TELL THEM TO OPEN SETTINGS OR CONTINUE WITHOUT
        else if status == .authorized {
            Button("CLOSE", systemImage: "face.smiling.inverse", action: nextStage)
                .buttonStyle(FilledRedButtonStyle())
                .tint(.green)
        }
    }


    private func nextStage() {
        // Move to the next permissions view
        showsAppBlockerPermission = true
    }
}

#Preview {
    NotificationPermissionView()
        .environment(NotificationPermissionsViewModel())
}
