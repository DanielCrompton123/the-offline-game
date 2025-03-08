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
        
        DynamicIslandExpandedRegion(.center) {
            
            if let endDate = context.state.endDate {
                // USE PROGRESSVIEW(TIME INTERVAL) INIT TO automatically update!!!
                
                ProgressView(timerInterval: context.state.startDate...endDate) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
                .tint(.accent)
                .scaleEffect(y: 2.2)
                
            } else {
                Text(context.state.startDate, style: .relative)
            }
            
        }
        
        
        
        DynamicIslandExpandedRegion(.bottom) {
            
            HStack(spacing: 0) {
                
                if let endDate = context.state.endDate {
                    Text("\(Text(endDate, style: .timer).foregroundStyle(.accent)) \(Date().distance(to: endDate) > 0 ? Text("left") : Text("OVERTIME"))!")
                        .multilineTextAlignment(.leading)
                        .font(.custom("Maquire", size: 60))
                        .frame(maxHeight: .infinity)
                        .padding()
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "iphone.gen3.slash")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .bold()
                    .foregroundStyle(.white)
                
            }
            
        }
                
    }
}




#Preview("Dynamic island extended", as: .dynamicIsland(.expanded), using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})
