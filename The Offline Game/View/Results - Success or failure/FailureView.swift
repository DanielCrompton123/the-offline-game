//
//  FailureView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/8/25.
//

import SwiftUI
import Lottie

struct FailureView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    @State private var notificationToastShows = false
    @State private var userWillBeReminded = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .accentColor, .ruby], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .overlay {
                    
                    // OFFLINE IMAGE
                    Image(.wifiBrushstroke)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 600)
                        .offset(x: 100, y: -100)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                    
                }
            
            content
            
        }
    }
    
    
    @ViewBuilder private var content: some View {
    
        VStack(spacing: 30) {
            Spacer()
            
            DelayedLottieAnimation(name: "Xmark", endCompletion: 0.95)
                .frame(height: 100)
                .scaleEffect(1.2)
            
            VStack {
                Text("You failed")
                    .font(.display108)
                Text("THE OFFLINE GAME")
                    .font(.main20)
            }
            
            if let elapsedTime = offlineViewModel.state.elapsedTime {
                
                let formattedDur = elapsedTime.offlineDisplayFormat()
                
                Text("You only spent \(formattedDur) offline!")
                    .opacity(0.75)
                    .font(.display40)
            }
            
            Spacer()
            
            Button {
                if let oldStartDate = offlineViewModel.state.oldStartDate {
                    OfflineReminderHelper.scheduleReminderForTomorrow(today: oldStartDate)
                }
                
                withAnimation {
                    notificationToastShows = true
                }
                
                userWillBeReminded = true
            } label: {
                Label {
                    Text("REMIND ME TO RETRY")
                        .minimumScaleFactor(0.6)
                        .padding(.horizontal)
                        .padding(.horizontal)
                } icon: {
                    Image(systemName: userWillBeReminded ? "checkmark.circle.fill" : "bell.badge")
                }
                .foregroundStyle(.accent)

            }
            .buttonStyle(FilledRedButtonStyle())
            .tint(.white)
            .disabled(userWillBeReminded)
            .padding(.horizontal, -40) // Opposite of the 40 padding on the stack
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
        .toast(isPresented: $notificationToastShows, duration: 4) {
            VStack(alignment: .leading) {
                Text("We will remind you to go offline again tomorrow.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.main20)
                
                Button("Actually, don't remind me",
                       systemImage: "bell.badge.slash") {
                    
                    OfflineReminderHelper.revokeOfflineReminder()
                    withAnimation {
                        notificationToastShows = false
                    }
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.main14)
            }
            .padding()
        }
        .onDisappear(perform: offlineViewModel.resetOfflineTime)
    }
}

#Preview {
    FailureView()
        .environment(OfflineViewModel())
}
