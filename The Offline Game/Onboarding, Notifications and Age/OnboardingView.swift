//
//  OnboardingViewRoot.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct OnboardingView: View {
        
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                // HEADER
                OfflineHeader()
                
                Spacer()
                
                // ONBOARDING CONTENT
                
                VStack(spacing: 10) {
                    onboardingItem(label: "Addicted to your phone?", systemImage: "brain.head.profile")
                    onboardingItem(label: "See how long you can go offline", systemImage: "stopwatch")
                    onboardingItem(label: "Challenge friends to do the same!", systemImage: "trophy")
                }
                .minimumScaleFactor(0.6)
                
                Spacer()
                
                NavigationLink("CONTINUE") {
                    // Link to the User Account Age View
                    AccountCreationAgeView()
                    // Because this view only opens on first launch, assume the user have not entered their age yet.
                }
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
                
            }
            .padding()
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
