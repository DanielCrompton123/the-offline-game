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
                
                if let date = context.state.offlineTime.endDate {
                    Text(date, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                } else if case let .overtime(startDate) = context.state.offlineTime {
                    Text(startDate, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .foregroundStyle(.green.gradient)
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
    LiveActivityTimerAttributes.ContentState.previewNormal
})



#Preview("Minimal", as: .dynamicIsland(.minimal), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewNormal
})

#Preview("Extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewNormal
})







#Preview("OVT Compact", as: .dynamicIsland(.compact), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewOvertime
})



#Preview("OVT Minimal", as: .dynamicIsland(.minimal), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewOvertime
})

#Preview("OVT Extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewOvertime
})
