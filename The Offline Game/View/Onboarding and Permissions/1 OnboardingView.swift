//
//  OnboardingViewRoot.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct OnboardingView: View {
    
    @AppStorage(K.userDefaultsUserAgeRawValueKey) private var userAgeRawValue: Int?
    
    @State private var navigateToAccountCreationAgeView = false
    @State private var navigateToNotificationPermissionsView = false
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer(minLength: 0)
                
                // HEADER
                OfflineHeader()
                
                Spacer(minLength: 0)
                
                // ONBOARDING CONTENT
                
                VStack(spacing: 10) {
                    onboardingItem(label: "Addicted to your phone?", systemImage: "brain.head.profile")
                    onboardingItem(label: "See how long you can go offline", systemImage: "stopwatch")
                    onboardingItem(label: "Challenge friends to do the same!", systemImage: "trophy")
                }
                .minimumScaleFactor(0.6)
                .padding(.horizontal)
                
                Spacer(minLength: 0)
                
                Button("Continue", systemImage: K.systemArrowIcon) {
                    // Link to the User Account Age View
                    navigateToAccountCreationAgeView = true
                }
                .buttonStyle(FilledRedButtonStyle())
                
            }
            .navigationDestination(isPresented: $navigateToAccountCreationAgeView) {
                AccountCreationAgeView()
                    .onChange(of: userAgeRawValue) { oldValue, newValue in
                        // When the user selects one, we should navigate to the next screen, the notification permissions screen
                        navigateToNotificationPermissionsView = true
                    }
                    .navigationDestination(isPresented: $navigateToNotificationPermissionsView) {
                        NotificationPermissionView()
                    }

            }
        }
    }
   
    
    @ViewBuilder func onboardingItem(label: String, systemImage: String) -> some View {
        let iconFont = Font.system(size: 48)
        
        HStack(spacing: 20) {
            Image(systemName: systemImage)
                .bold()
                .foregroundStyle(.accent)
                .font(iconFont)
            
            Text(label)
                .font(.main20)
                .foregroundStyle(.smog)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

#Preview {
    OnboardingView()
}
