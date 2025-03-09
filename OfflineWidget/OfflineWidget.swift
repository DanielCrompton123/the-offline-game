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
    
    @State private var ovtStart = Date()
    
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: LiveActivityTimerAttributes.self) { context in
            
            LockScreenLiveActivityView(context: context)
            
        } dynamicIsland: { context in
            
            DynamicIsland {
                
                ExtendedDynamicIsland(context: context).body()
                
            } compactLeading: {
                
                Image(systemName: "iphone.gen3.slash")
                    .bold()
                    .foregroundStyle(
                        (context.state.isOvertime ? Color.green : Color.red)
                            .gradient
                    )
                    .frame(width: 40)
                
            } compactTrailing: {
                
                switch context.state.offlineTime {
                    // COUNT-DOWN TIMER
                case .normal:
                        
                    Text(context.state.offlineTime.endDate!, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                    // WARNING: CANNOT ADD COLOR.GRADIENT TO THE TIMER TEXT for some reason
                    // It will not count up or down

                    // COUNT-UP TIMER (FOR OVERTIME)
                case let .overtime(startDate):
                    Text(startDate, style: .timer)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                    
                    // WARNING: CANNOT ADD COLOR.GRADIENT TO THE TIMER TEXT for some reason
                    // It will not count up or down
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
