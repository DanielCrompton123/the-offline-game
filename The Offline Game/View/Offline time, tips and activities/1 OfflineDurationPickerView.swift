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
    @AppStorage(K.userDefaultsShouldShowActivitiesViewKey) private var shouldShowActivitiesView = true
    @State private var tipsViewPresented = false
    @State private var activitiesViewPresented = false
            
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
                
                Button("CONTINUE", action: nextStage)
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
            }
            .font(.main30)
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .padding()
            .navigationDestination(isPresented: $tipsViewPresented) {
                TipView()
            }
            .navigationDestination(isPresented: $activitiesViewPresented) {
                ActivitiesView()
            }

        }
        
        // When the offline duration picker shows, start listening for network connectivity changes.
        
        // This allows us to check if wifi is on or off
        // That is used to determine if we should present the tips view or not, since we don't ned to tell them to turn off wifi if they did already.
        .onAppear(perform: NetworkMonitor.shared.startListening)
    }
    
    
    @ViewBuilder private func durationDisplay() -> some View {
        let time = DurationDisplayHelper.formatDurationWithUnits(offlineViewModel.durationSeconds)
        
        Text(time.timeString)
            .font(.display256)
            .foregroundStyle(.accent)
            .contentTransition(.numericText()) // NOT WORKING
        
        Text(time.unitString)
    }
    
    
    private func nextStage() {
        // If the wifi is turned on (use network monitor for this) then present the tips view sheet telling them to turn it off
        if NetworkMonitor.shared.isConnected {
            tipsViewPresented = true
            
            // tips view can navigate from there
        }
        
        // If we have wifi turned off BUT this is the first app usage, navigate to the activities view
        else if shouldShowActivitiesView {
            activitiesViewPresented = true
        }
        
        // If we already had wifi off AND don't need to see activities, just go offline
        else {
            offlineViewModel.goOffline()
        }
    }
    
}

#Preview {
    OfflineDurationPickerView()
        .environment(OfflineViewModel())
}
