//
//  OfflineTimeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI

struct OfflineDurationPickerView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    @State private var tipViewPresented = false
        
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        NavigationStack {
            
            
            VStack(spacing: 10) {
                
                Spacer()
                
                Text("How long do you want to go offline for?")
                
                durationDisplay()
                
                Slider(value: $offlineViewModel.durationMinutes,
                       in: K.offlineDurationRange,
                       step: K.minuteStep) {
                    Text(String(format: "%.0f minutes", offlineViewModel.durationMinutes))
                    // for screen readers
                }
                .labelsHidden()
                
                Spacer()
                
                Button("CONTINUE") {
                    tipViewPresented = true
                }
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
            }
            .font(.main30)
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .padding()
            .navigationDestination(isPresented: $tipViewPresented) {
                TipView()
            }
            
            
            
        }
    }
    
    
    @ViewBuilder private func durationDisplay() -> some View {
        let time = DurationDisplayHelper.formatDurationWithUnits(offlineViewModel.durationSeconds)
        
        Text(time.timeString)
            .font(.display256)
            .foregroundStyle(.accent)
            .contentTransition(.numericText()) // NOT WORKING
        
        Text(time.unitString)
    }
    
}

#Preview {
    OfflineDurationPickerView()
        .environment(OfflineViewModel())
}
