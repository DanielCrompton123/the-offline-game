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
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            content()
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
        }
        .activityBackgroundTint(.accent)
    }
    
    
    @ViewBuilder private func content() -> some View {
        
        HStack(spacing: 24) {
            
            // IMAGE
            Image(systemName: "iphone.gen3.slash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .bold()
                .frame(maxHeight: 80)
            
            
            // RIGHT HAND CONTENT
            VStack(alignment: .trailing, spacing: 16) {
                
                // ENCOURAGEMENT + TIME REMAINING
                VStack(alignment: .trailing, spacing: 2) {
                    Text("YOU'RE DOING GREAT!")
                        .font(.main14)
                        .foregroundStyle(.smog.mix(with: .white, by: 0.5))
                    
                    if let endDate = context.state.endDate {
                        Text("\(Text(endDate, style: .timer)) \(Date().distance(to: endDate) > 0 ? Text("left") : Text("OVERTIME"))!")
                            .multilineTextAlignment(.trailing)
                            .font(.display40)
                        
                    }
                    
                }
                
                // PROGRESS BAR
                if let endDate = context.state.endDate {
                    // USE PROGRESSVIEW(TIME INTERVAL) INIT TO automatically update!!!
                    
                    ProgressView(timerInterval: context.state.startDate...endDate) {
                        EmptyView()
                    } currentValueLabel: {
                        EmptyView()
                    }
                    .tint(.white)
                    .scaleEffect(y: 2.2)
                    
                }

            }
        }
        .foregroundStyle(.white)
    }
    

}

#Preview("Dynamic island extended", as: .content, using: LiveActivityTimerAttributes.preview, widget: {
    OfflineWidget()
}, contentStates: {
    LiveActivityTimerAttributes.ContentState.preview
})
