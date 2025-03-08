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
                
                ExtendedDynamicIsland(context: context).body()
                
            } compactLeading: {
                
                Image(systemName: "iphone.gen3.slash")
                    .bold()
                    .foregroundStyle(.red.gradient)
                    .frame(width: 40)
                
            } compactTrailing: {
                
                if let date = context.state.endDate {
                    Text(date, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                }
                
            } minimal: {
                Image(systemName: "iphone.gen3.slash")
                    .bold()
                    .foregroundStyle(.red.gradient)
            }
            
        }
        
    }
}


#Preview("Compact", as: .dynamicIsland(.compact), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})



#Preview("Minimal", as: .dynamicIsland(.minimal), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})

#Preview("Extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})
