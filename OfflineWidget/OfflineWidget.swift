//
//  OfflineWidget.swift
//  OfflineWidget
//
//  Created by Daniel Crompton on 12/6/24.
//

import WidgetKit
import SwiftUI
import ActivityKit




struct OfflineWidget: Widget {
    let kind: String = "OfflineWidget"
    
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: LiveActivityTimerAttributes.self) { context in
            
            LockScreenLiveActivityView(context: context)
            
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
