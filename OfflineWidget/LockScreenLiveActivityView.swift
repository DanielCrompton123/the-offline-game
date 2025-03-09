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
                    
                    switch context.state.offlineTime {
                        
                        // COUNTDOWN TIMER
                    case .normal:
                        
                        Text("\(Text(context.state.offlineTime.endDate!, style: .timer)) left!")
                            .multilineTextAlignment(.trailing)
                            .font(.display40)
                        
                        
                        // COUNT-UP FOR OVERTIME
                    case let .overtime(startDate):
                        
                        Text("\(Text(startDate, style: .timer)) OVERTIME!")
                            .multilineTextAlignment(.trailing)
                            .font(.display40)
                        
                    }
                    
                }
                
                // PROGRESS BAR if we are counting down to an end date
                if case let .normal(_, startDate) = context.state.offlineTime,
                   let endDate = context.state.offlineTime.endDate {
                    
                    // USE PROGRESSVIEW(TIME INTERVAL) INIT TO automatically update!!!
                    ProgressView(timerInterval: startDate...endDate) {
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
    LiveActivityTimerAttributes.ContentState.previewNormal
})
