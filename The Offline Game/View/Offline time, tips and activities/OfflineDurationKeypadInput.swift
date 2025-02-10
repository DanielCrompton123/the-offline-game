//
//  OfflineDurationKeypadInput.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/10/25.
//

import SwiftUI

struct OfflineDurationKeypadInput: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    @State private var hrsText = "0"
    @State private var minsText = "0"
    @State private var secsText = "0"
    
    var body: some View {
        
        ZStack {
            
            Image(systemName: "timer")
                .resizable()
                .scaledToFit()
                .fontWeight(.black)
                .foregroundStyle(.smog.mix(with: .accent, by: 0.2))
                .opacity(0.1)
                .rotationEffect(.degrees(10))
            
            
            VStack(spacing: 30) {
                
                // HEADER
                Text("Input duration")
                    .font(.display40)
                
                // TEXT FIELDS
                // Display text fields for hour, minute, second.
                // Text fields input is numeric
                // When the text field was dismissed, then use date components to find the date
                
                HStack(spacing: 30) {
                    textField("Hours", text: $hrsText)
                    textField("Minutes", text: $minsText)
                    textField("Seconds", text: $secsText)
                }
                
            }
            .padding(.horizontal)
            .padding(.horizontal)
            
            
        }
    }
    
    
    @ViewBuilder private func textField(_ placeholder: String, text: Binding<String>) -> some View {
        
        VStack {
            Text(placeholder)
                .font(.main20)
                .textCase(.uppercase)
                .foregroundStyle(.smog)
            
            TextField("", text: text)
                .keyboardType(.numberPad)
                .font(.display88)
                .foregroundStyle(.ruby)
                .multilineTextAlignment(.center)
            
            Line(start: .leading, end: .trailing)
                .stroke(.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [0.1, 12]))
                .frame(height: 1)
                .offset(y: -8)

        }
        .minimumScaleFactor(0.4)
        .lineLimit(1)
        
    }
}

#Preview {
    OfflineDurationKeypadInput()
        .environment(OfflineViewModel())
}
