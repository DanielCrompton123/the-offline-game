//
//  OfflineView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI



struct OfflineView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var showActivitiesView = false
    @State private var goOnlineConfirmationShows = false
    @State private var rulesScreenShows = false
    
    var body: some View {
        ZStack {
            
            Color.accentColor
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [.ruby.opacity(0.5), .clear, .ruby],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image(.wifiBrushstrokeSlash)
                .resizable()
                .scaledToFit()
                .scaleEffect(1.2)
                .foregroundStyle(.ruby)
                .opacity(0.5)
                .rotationEffect(.degrees(10), anchor: .bottom)
                .offset(y: -100)
            
            VStack {
                
                Spacer()
                
                // don't display the progress view if we're not in overtime
                if !offlineViewModel.state.isInOvertime {
                    
                    OfflineProgressView()
                        .padding(.horizontal)
                    
                }
                
                Text("I'm offline")
                    .font(.display88)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(.black)
                
                if offlineViewModel.state.isInOvertime,
                   let overtimeStartDate = offlineViewModel.state.overtimeStartDate {
                    
                    Text("Overtime!")
                        .font(.display40)
                        .foregroundStyle(.white)
                    
                    // Now display the text for the overtime duration
                    // count UP
                    // If the date is > current date, Text will count up from it
                    
                    // Don't forget to deduct the pause duration off it
                    Text(overtimeStartDate.addingTimeInterval(offlineViewModel.state.totalOvertimePauseDuration.seconds), style: .timer)
                        .font(.display128)
                        .foregroundStyle(.green.gradient)
                    
                }
                    
                Spacer()
                
                Button("WHAT TO DO?", systemImage: activityViewModel.activityIcon) {
                    showActivitiesView = true
                }
                .tint(.white)
                .buttonStyle(RedButtonStyle(horizontalContentMode: .fit))
                .onAppear {
                    activityViewModel.startUpdatingActivityIcon(timeInterval: 5)
                }
                .onDisappear(perform: activityViewModel.stopUpdatingActivityIcon)
                
                Button("I NEED A BREAK", systemImage: "iphone.and.arrow.left.and.arrow.right.inward") {
                    goOnlineConfirmationShows = true
                }
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
                
                Button("HOW IT WORKS", systemImage: "info.triangle") {
                    rulesScreenShows = true
                }
                .tint(.white)
                .buttonStyle(RedButtonStyle(horizontalContentMode: .fit))

            }
            
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        
        .sheet(isPresented: $showActivitiesView) {
            ActivitiesView()
        }
        
        .confirmationDialog("You will loose your offline progress!", isPresented: $goOnlineConfirmationShows, titleVisibility: .visible) {
            
            // OK BUTTON
            Button(
                offlineViewModel.state.isInOvertime ?
                "I'm finished with my overtime now." :
                "I really need my phone :(",
                role: .destructive
            ) {
                offlineViewModel.endOfflineTime(successfully: true)
            }
            
            // CANCEL BUTTON
            Button(
                offlineViewModel.state.isInOvertime ?
                "Actually, I want to continue!" :
                "I refuse to be defeated!",
                role: .cancel) {
                    
                goOnlineConfirmationShows = false
                    
            }
        }
        .sheet(isPresented: $rulesScreenShows) {
            OfflineRules()
                .presentationDragIndicator(.visible)
        }
    }

}

#Preview {
    OfflineView()
        .environment(OfflineViewModel())
        .environment(ActivityViewModel())
}
