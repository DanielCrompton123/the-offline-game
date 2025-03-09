//
//  ExtendedDynamicIsland.swift
//  OfflineWidgetExtension
//
//  Created by Daniel Crompton on 3/8/25.
//

import SwiftUI
import WidgetKit
import ActivityKit


struct ExtendedDynamicIsland {
    
    let context: ActivityViewContext<LiveActivityTimerAttributes>
    
    
    @DynamicIslandExpandedContentBuilder
    func body() -> DynamicIslandExpandedContent<some View> {
        
        //MARK: - Center
        DynamicIslandExpandedRegion(.center) {
            
            // PROGRESS BAR (if we are counting down to offline end)
            if case let .normal(_, startDate) = context.state.offlineTime,
               let endDate = context.state.offlineTime.endDate {
                
                // USE PROGRESSVIEW(TIME INTERVAL) INIT TO automatically update!!!
                
                ProgressView(timerInterval: startDate...endDate) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
                .tint(.accent)
                .scaleEffect(y: 2.2)
                
            }
        }
        
        //MARK: - Bottom
        DynamicIslandExpandedRegion(.bottom) {
            
            HStack(spacing: 0) {
                
                // COUNTDOWN TIMER (or count-up for overtime)
                if let endDate = context.state.offlineTime.endDate {
                    Text("\(Text(endDate, style: .timer).foregroundStyle(.accent)) left!")
                        .multilineTextAlignment(.leading)
                        .font(.custom("Maquire",size: 60))
                        .frame(maxHeight: .infinity)
                        .padding()
                }
                else if case let .overtime(startDate) = context.state.offlineTime {
                    
                    Text("\(Text(startDate, style: .timer).foregroundStyle(.green.gradient)) OVERTIME!")
                        .multilineTextAlignment(.leading)
                        .font(.custom("Maquire", size: 60))
                        .minimumScaleFactor(0.2)
                        .frame(maxHeight: .infinity)
                        .padding()
                    
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "iphone.gen3.slash")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .bold()
                    .foregroundStyle(context.state.isOvertime ? AnyShapeStyle(.green.gradient) : AnyShapeStyle(.white))
                
            }
            
        }
                
    }
}


#Preview("Dynamic island extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewNormal
})


#Preview("OVT Dynamic island extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.previewOvertime
})
