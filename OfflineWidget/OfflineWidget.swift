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
                        
                        let timeElapsed = context.state.startDate.distance(to: Date())
                        let offlineTimeElapsedString = DurationDisplayHelper.formatDuration(timeElapsed)
                        
                        Text("You've been offline for \(offlineTimeElapsedString), keep going!")
                            .font(.callout)
                        
//                        // DOESN'T UPDATE!!!
//                        if let endDate = context.state.endDate {
//                            TimelineView(.animation) { _ in
//                                let offlineCompletion = context.state.startDate.completionTo(endDate)
//                                let _ = print("Refreshing offline widget view now")
//                                Gauge(value: offlineCompletion) {
//                                    Label("Offline...", systemImage: K.systemOfflineIcon)
//                                }
//                                .tint(.white)
//                            }
//                        }
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
                DynamicIslandExpandedRegion(.leading) {
                    Image(.offlineIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(.smog)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Don't use your phone when you are offline!")
                    //                        .font(.system(size: 18))
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(.smog)
                        .multilineTextAlignment(.trailing)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Divider()
                    
                    Text("I'm offline!")
                        .frame(maxWidth: .infinity)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.linearGradient(colors: [.accent, .ruby], startPoint: .top, endPoint: .bottom))
                }
                
                DynamicIslandExpandedRegion(.center) {
                    if let endDate = context.state.endDate {
                        Text("\(Text(endDate, style: .timer).bold()) offline")
                            .multilineTextAlignment(.center)
                    }
                    
                }
            } compactLeading: {
                Image(.offlinePhone)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red.gradient)
                
            } compactTrailing: {
                if let date = context.state.endDate {
                    Text(date, style: .timer)
                        .multilineTextAlignment(.trailing)
                }
                
            } minimal: {
                Image(.offlinePhone)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red.gradient)
            }
            
        }
        
    }
}


#Preview("Dynamic island compact", as: .dynamicIsland(.compact), using: LiveActivityTimerAttributes(), widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})



#Preview("Dynamic island minimal", as: .dynamicIsland(.minimal), using: LiveActivityTimerAttributes(), widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})

#Preview("Dynamic island extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes(), widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})
