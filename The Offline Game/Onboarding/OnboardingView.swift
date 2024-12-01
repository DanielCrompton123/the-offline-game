//
//  OnboardingViewRoot.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import UserNotifications


fileprivate enum OnboardingStep {
    case stageA, stageB
}


struct OnboardingView: View {
    @State private var step = OnboardingStep.stageA
        
    var body: some View {
        VStack(spacing: 20) {
            
            // HEADER
            OfflineHeader()
            
            Spacer()
            
            // ONBOARDING CONTENT
            
            VStack {
                if step == .stageA {
                    onboardingA
                    
                } else if step == .stageB {
                    onboardingB
                    
                }
            }
            
        }
        .buttonStyle(FilledRedButtonStyle())
        .padding()
    }
    
    
    @ViewBuilder private var onboardingA: some View {
        VStack(spacing: 10) {
            onboardingItem(label: "Addicted to your phone?", systemImage: "brain.head.profile")
            onboardingItem(label: "See how long you can go offline", systemImage: "stopwatch")
            onboardingItem(label: "Challenge friends to do the same!", systemImage: "trophy")
            
            Spacer()
            
            Button("CONTINUE") {
                if step == .stageA {
                    step = .stageB
                }
            }
        }
        .minimumScaleFactor(0.6)

    }
    
    
    @ViewBuilder private var onboardingB: some View {
        NotificationPermissionView()
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
