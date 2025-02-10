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
    @State private var selectedRange: DurationRange?
    @State private var secs = 0.0
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
                
        VStack {
            
            if let selectedRange {
                // If we have selected a range then display the ruler for it.
                
                VStack {
                    
                    // the arrow pointing down to the current value
                    Image(.arrow)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .frame(height: 40)
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .leading) {
                            Button("Back", systemImage: "arrow.backward") {
                                self.selectedRange = nil
                            }
                            .font(.main14)
                            .padding(.leading)
                            .tint(.smog)
                        }
                    
                    HorizontalRulerSlider(
                        value: $secs,
                        range: selectedRange.rangeInSecs,
                        step: selectedRange.step,
                        spacing: selectedRange.spacing,
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
                                .font(.caption)
                                .frame(width: 30)
                                .foregroundStyle(.smog)
                        }
                        
                    }
                    
                }
                
            } else {
                // If we have not selected a range, then display the selector
                DurationRangeSelector(range: $selectedRange)
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
            
        }
    }
    
    
}


//MARK: - RANGE SELECTION
// Allow the user to select a range (each range has a different step value).

fileprivate struct DurationRangeSelector: View {
    @Binding var range: DurationRange?
    
    var body: some View {
        
        VStack(spacing: 20) {
            ForEach(DurationRange.allCases, id: \.self) { range in
                rangeSelector(range)
            }
        }
        .overlay(alignment: .leading) {
            // Overlay the vertical line through the dots in the range buttons
            Capsule()
                .fill(.smog)
                .frame(width: 4)
                .offset(x: (25 / 2) - (4 / 2)) // offset half the width of the dots
        }
        
    }
    
    
    @ViewBuilder private func rangeSelector(_ range: DurationRange) -> some View {
        
        HStack(spacing: 16) {
            Circle()
                .fill(.smog)
                .frame(width: 25, height: 25)

            Text(range.formatted())
                .font(.main20)
                .foregroundStyle(.accent)
            
            Spacer()
        }
        .onTapGesture {
            self.range = range
        }
        
    }
}


#Preview {
    OfflineDurationPickerView()
        .environment(OfflineViewModel())
}
