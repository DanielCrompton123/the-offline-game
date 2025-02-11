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

    @FocusState private var secsIsFocused: Bool
    @FocusState private var minsIsFocused: Bool
    @FocusState private var hrsIsFocused: Bool
    
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
                    textField("Hours", text: $hrsText, isFocused: $hrsIsFocused)
                    textField("Minutes", text: $minsText, isFocused: $minsIsFocused)
                    textField("Seconds", text: $secsText, isFocused: $secsIsFocused)
                }
                
            }
            .padding(.horizontal)
            .padding(.horizontal)
            
            
        }
        .onAppear(perform: loadStrings)
        .toolbar {
            
            // Put the DONE button for the text fields here instead of on the text field because on the text field makes it appear once for each text field
            // All .toolbar()s are combined together
            
            ToolbarItemGroup(placement: .keyboard) {

                // Push the button to the right
                Spacer()

                // DONE BUTTON
                Button {
                    setDuration()
                    
                    // Also dismiss the text fields (all of them)
                    secsIsFocused = false
                    minsIsFocused = false
                    hrsIsFocused = false
                } label: {
                    Label("Done", systemImage: "checkmark.circle.fill")
                        .labelStyle(.titleAndIcon)
                }
            }

        }
    }
    
    
    @ViewBuilder private func textField(_ placeholder: String, text: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        
        VStack {
            Text(placeholder)
                .font(.main20)
                .textCase(.uppercase)
                .foregroundStyle(.smog)
            
            TextField("", text: text)
                .font(.display88)
                .foregroundStyle(.ruby)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onSubmit(setDuration)
                .focused(isFocused)
            
            Line(start: .leading, end: .trailing)
                .stroke(.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [0.1, 12]))
                .frame(height: 1)
                .offset(y: -8)

        }
        .minimumScaleFactor(0.4)
        .lineLimit(1)
        
    }
    
    
    private func loadStrings() {
        // Turn the duration into string values for the text fields to edit
        let strings = offlineViewModel.state.durationSeconds.strings()
        
        hrsText = strings.hour
        minsText = strings.minute
        secsText = strings.second
    }
    
    
    private func setDuration() {
        
        if let totalSeconds = Duration.fromStrings(hour: hrsText, minute: minsText, second: secsText) {
            
            offlineViewModel.state.durationSeconds = totalSeconds
        } else {
            print("Could not create text from hrs/mins/secsText")
        }
    }
}

#Preview {
    
    let vm = {
        let vm = OfflineViewModel()
        vm.state.durationSeconds = .seconds(120)
        return vm
    }()
    OfflineDurationKeypadInput()
        .environment(vm)
}
