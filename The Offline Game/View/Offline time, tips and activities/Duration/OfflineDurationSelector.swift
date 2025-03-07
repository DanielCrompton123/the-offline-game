//
//  OfflineDurationSelector.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/10/25.
//

import SwiftUI


//MARK: - MAIN

struct OfflineDurationSelector: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @State private var secs = 0.0
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
                
        durationSlider()
            .onChange(of: secs) { oldValue, newValue in
                offlineViewModel.state.durationSeconds = .seconds(secs)
            }
            .onAppear {
                // Make sure the offline view model slider value is synchronised to here
                secs = offlineViewModel.state.durationSeconds.seconds
            }
    }
    
    
    @ViewBuilder private func durationSlider() -> some View {
        
        // Maximum = 12 hours
        let maxSecs: Double = Measurement(value: 12, unit: UnitDuration.hours).converted(to: .seconds).value
        // Minimum = 5 minutes
        let minSecs: Double = 60 * 5
        
        // Step 10 minutes
        let step: Double = 600
        
        // Spacing between markers = 30 pts
        let spacing: CGFloat = 35
        
        VStack {
            
            // the arrow pointing down to the current value
            Image(.arrow)
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(90))
                .frame(height: 40)
                .foregroundStyle(.accent)

            HorizontalRulerSlider(
                value: $secs,
                range: minSecs...maxSecs,
                step: step,
                spacing: spacing,
                alignment: .top
            ) { value in
                
                VStack(spacing: 20) {
                    Image(.shortLine)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(.ruby)
                        .frame(height: 5)
                    
                    // For the value in the text for the marker, then display the formatted value
                    Text( Duration.seconds(value).offlineDisplayFormat(width: .abbreviated) )
                        .font(.caption.width(.condensed))
                        .bold()
                        .frame(width: 30)
                        .foregroundStyle(.smog)
                        .minimumScaleFactor(0.2)
                }
                
            }
            
        }
        
    }
    
    
}

#Preview {
    OfflineDurationPickerView()
        .environment(OfflineViewModel())
}
