//
//  OnboardingViewRoot.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI
import AVFoundation


struct OnboardingView: View {
    @State private var tab = 0
    
    var body: some View {
        VStack(spacing: 20) {
                        
            // HEADER
            OfflineHeader()
            
            Spacer()
            
            Group {
                // ONBOARDING CONTENT
                switch tab {
                case 0:
                    onboardingContent1
                case 1:
                    onboardingContent2
                default:
                    Text("tab \(tab) should be handled")
                }
            }
            .padding(.horizontal, 26)
            
            Spacer()
            
            if tab == 0 {
                Button("CONTINUE") {
                    withAnimation {
                        tab += 1
                    }
                }
            }
            
            else if tab == 1 {
                Button("ASK PERMISSION",
                       action: getNotificationPermission)
            }
        }
        .buttonStyle(FilledRedButtonStyle())
        .padding(.bottom)
    }

    
    @ViewBuilder
    private var onboardingContent1: some View {
        VStack(spacing: 10) {
            onboardingItem(label: "Addicted to your phone?", systemImage: "brain.head.profile")
            onboardingItem(label: "See how long you can go offline...", systemImage: "stopwatch")
            onboardingItem(label: "Challenge friends to do the same!", systemImage: "trophy")
        }
        .minimumScaleFactor(0.6)
    }
    
    
    @ViewBuilder
    private var onboardingContent2: some View {
        Text("We need to send you notifications to help you track your offline time.\nPLEASE PRESS “ACCEPT” TO THE MESSAGE")
            .font(.main20)
            .foregroundStyle(.accent)
            .multilineTextAlignment(.center)
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
    
    
    
    private func getNotificationPermission() {
        
    }
}

#Preview {
    OnboardingView()
}
