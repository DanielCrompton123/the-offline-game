//
//  OfflineProgressView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/3/24.
//

import SwiftUI


struct OfflineProgressView: View {
    @Environment(OfflineViewModel.self) private var offlineViewModel
        
    var body: some View {
        
        VStack(spacing: 20) {
            
            // COUNTDOWN TIMER -- see how long to go
            if let endDate = offlineViewModel.endDate {
                Text(endDate, style: .timer)
                    .font(.display88)
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(countsDown: true))
            }
            
            // PROGRESS VIEW -- see how long's been
            TimelineView(.animation) { _ in
                if let offlineProgress = offlineViewModel.offlineProgress,
                   let elapsedTime = offlineViewModel.elapsedTime {
                                        
                    Gauge(value: offlineProgress) {
                        // Label
                        Label("Offline duration", systemImage: "wifi.exclamationmark")
                    } currentValueLabel: {
                        // Current value -- display "7Hrs offline (so far)"
                        let formattedElapsedTime = DurationDisplayHelper.formatDuration(elapsedTime)
                        
                        Text(formattedElapsedTime)
                            .font(.main14)
                    }
                    .padding(.horizontal)
                    .gaugeStyle(FatGaugeStyle(isTall: true))
                                        
                }
            }
            
        }
        
    }
}
