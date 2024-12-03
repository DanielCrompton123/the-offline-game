//
//  OfflineTimeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI

struct OfflineTimeView: View {
        
    private let minuteRange: ClosedRange<TimeInterval> = 5...(24 * 60) // maximum offline duration is a day; minimum is 5 minutes
    
    private let minuteStep: TimeInterval = 1 // Slider increments in minutes
    
    @Environment(\.dismiss) private var dismiss
    @Environment(OfflineViewModel.self) private var offlineViewModel
        
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        VStack(spacing: 10) {
            
            Spacer()
            
            Text("How long do you want to go offline for?")
        
            durationDisplay()
            
            Slider(value: $offlineViewModel.offlineMinutes, in: minuteRange, step: minuteStep) {
                Text("\(offlineViewModel.offlineMinutes) minutes")
                // for screen readers
            }
            .labelsHidden()
            
            Spacer()
            
            Button("CONTINUE") {
                startOffline()
            }
            .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
        }
        .font(.main30)
        .textCase(.uppercase)
        .multilineTextAlignment(.center)
        .padding()
    }
    
    
    @ViewBuilder private func durationDisplay() -> some View {
        // If the time is a number of minutes (e.g. 0 to 59 minutes) -- use the minuteRange for this -- then display "XX MINUTES",
        // If it's a number of hours, display "XX.X hours"
        
        let isMinutes = minuteRange.contains(offlineViewModel.offlineMinutes)
        let string = isMinutes ?
        String(format: "%.0f", offlineViewModel.offlineMinutes) : // Mins
        String(format: "%.1f", offlineViewModel.offlineMinutes / 60) // Mins -> Hrs
        
        Text(string)
            .font(.display256)
            .foregroundStyle(.accent)
            .contentTransition(.numericText())
        
        Text(isMinutes ? "Minutes" : "Hours")
    }
    
    
    private func startOffline() {
        dismiss()
        // Now navigate to the offline time view
        
        offlineViewModel.goOffline()
    }
}

#Preview {
    OfflineTimeView()
        .environment(OfflineViewModel())
}
