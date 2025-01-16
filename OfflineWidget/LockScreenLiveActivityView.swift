//
//  LockScreenLiveActivityView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI
import WidgetKit
import ActivityKit



struct LockScreenLiveActivityView : View {
    let context: ActivityViewContext<LiveActivityTimerAttributes>
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.ruby, .accent],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            HStack {
                Image(.offlineIcon)
                    .padding()
                
                VStack {
                    Group {
                        Text("Don't use your phone!")
                            .font(.title3)
                            .bold()
                        
                        let timeElapsed = context.state.startDate.distance(to: Date())
                        let offlineTimeElapsedString = Duration.seconds(timeElapsed).offlineDisplayFormat()
                        
                        Text("You've been offline for \(offlineTimeElapsedString), keep going!")
                            .bold()
                        
                        if let endDate = context.state.endDate {
                            // USE PROGRESSVIEW(TIME INTERVAL) INIT TO automatically update!!!
                            ProgressView(timerInterval: context.state.startDate...endDate) {
                                Label {
                                    Text("Offline...")
                                } icon: {
                                    Image(.offlinePhone)
                                }

                            }
                            .tint(.white)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Text("\(context.state.peopleOffline) others are offline right now!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .lineSpacing(-1.5)
                .foregroundStyle(.white)
            }
            .padding(.horizontal)
            
        }
    }
}
