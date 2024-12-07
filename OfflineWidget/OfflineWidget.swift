//
//  OfflineWidget.swift
//  OfflineWidget
//
//  Created by Daniel Crompton on 12/6/24.
//

import WidgetKit
import SwiftUI
import ActivityKit


struct TimerView : View {
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
                            .font(.headline)
                        
                        Text("You've been offline for 45 minutes, you can do it!")
                            .font(.callout)
                        
                        ProgressView(value: context.state.offlineDurationProgress)
                            .tint(.white)
                        
                        Text("\(context.state.peopleOffline) other people are offline right now!")
                            .font(.caption)
                            .foregroundStyle(.ruby)
                            .brightness(0.5)
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

struct OfflineWidget: Widget {
    let kind: String = "OfflineWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityTimerAttributes.self) { context in
            
            TimerView(context: context)
            
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Dynamic island isn't supported yet")
                }
            } compactLeading: {
                Text("Dynamic island isn't supported yet")
            } compactTrailing: {
                Text("Dynamic island isn't supported yet")
            } minimal: {
                Text("Dynamic island isn't supported yet")
            }
            
        }
        
    }
}
