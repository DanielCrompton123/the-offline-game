//
//  NotificationPermissionView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI
import FamilyControls


struct FamilyControlsPermissionView: View {
    @Environment(AppBlockerViewModel.self) private var appBlockerViewModel
    @AppStorage(K.userDefaultsShouldShowOnboardingKey) private var shouldShowOnboarding = false
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.dismiss) private var dismiss
    
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
                
                Text("APP BLOCKING")
                    .font(.display88)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            if let status = appBlockerViewModel.status {
                
                description(for: status)
                    .padding(.horizontal)
                
                Spacer()
                
                buttons(for: status)
            }
            
            else {
                ProgressView("Loading FamilyControls status")
            }
        }
        
        // Load the notification status when the UI appears with high priority
        .onAppear {
            // Subscribe to changes of the status
            AppBlockerViewModel.authorizationCenter.$authorizationStatus.sink { status in
                // Update the VM's status when this publishes
            }
        }
        .font(.main20)
        .multilineTextAlignment(.center)
        .textCase(.uppercase)
    }
    
    
    @ViewBuilder
    private func description(for status: AuthorizationStatus) -> some View {
        
        switch status {
        case .notDetermined:
            
            Text("We need to get your permission to block apps from opening.\nYOU NEED TO ACCEPT TO USE HARD COMMIT")
                .foregroundStyle(.accent)

        case .denied:
            
            Text("You have denied permissions to block apps in the past. Open settings to continue")
                .foregroundStyle(.ruby)
            
        case .approved:
            
            Text("All good. You have authorized app blocking")
                .foregroundStyle(.green)
            
        @unknown default:
            fatalError()
        }
    }
    
    
    @ViewBuilder
    private func buttons(for status: AuthorizationStatus) -> some View {
        
        // NOTIFICATIONS NOT ASKED FOR: ASK PERMISSION
        
        switch status {
        case .notDetermined:
            Button("GET PERMISSION",
                   systemImage: "questionmark.app.dashed") {
                
                Task {
                    do {
                        try await appBlockerViewModel.requestPermission()
                    } catch {
                        print("🧑‍🧑‍🧒‍🧒 Failed to request permission for FamilyControls: \(error)")
                    }
                }
            }
                   .buttonStyle(FilledRedButtonStyle())
            
        // FAMILY CONTROLS DENIED: TELL THEM TO OPEN SETTINGS OR CONTINUE WITHOUT
        case .denied:
            Button("CONTINUE WITHOUT",
                   systemImage: "app",
                   action: endOnboarding)
            .buttonStyle(RedButtonStyle())
            
            Button("OPEN IN SETTINGS",
                   systemImage: "gear") {
                
                if UIApplication.shared.canOpenURL(K.appSettingsURL) {
                    UIApplication.shared.open(K.appSettingsURL)
                } else {
                    print("🧑‍🧑‍🧒‍🧒 Cannot open Settings to enable the family controls")
                }
            }
                   .buttonStyle(FilledRedButtonStyle())
            
        // NOTIFICATIONS ALLOWED: JUST CLOSE
        case .approved:
            Button("CLOSE", systemImage: "lock.app.dashed", action: endOnboarding)
                .buttonStyle(FilledRedButtonStyle())
                .tint(.green)
            
        @unknown default:
            fatalError()
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
    FamilyControlsPermissionView()
        .environment(NotificationPermissionsViewModel())
        .environment(AppBlockerViewModel())
}
