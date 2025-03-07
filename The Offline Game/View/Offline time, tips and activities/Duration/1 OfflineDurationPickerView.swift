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
//    @State private var tipsViewPresented = false
    @State private var activitiesViewPresented = false
    @State private var wifiAnimate = true
    @State private var keypadInputViewShows = false
        
    private let wifiLogoRotation: Double = 15
    
            
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        NavigationStack {
            
            VStack(spacing: 10) {
                
                Spacer()
                
                // HEADER
                ZStack(alignment: .bottom) {
                    Image(.wifiBrushstrokeSlash)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 150)
                        .foregroundStyle(.smog)
                        .opacity(0.25)
                        .scaleEffect(1.75)
                        .offset(x: wifiAnimate ? -15 : 15)
                        .rotationEffect(
                            .degrees(wifiAnimate ? -wifiLogoRotation : wifiLogoRotation),
                            anchor: .bottom
                        )
                        .animation(.easeInOut(duration: 4.5).repeatForever(), value: wifiAnimate)
                        .onAppear {
                            wifiAnimate.toggle()
                        }
                    
                    Text("How long do you want to go offline for?")
                        .padding()
                }
                
                durationDisplay()
                
                Spacer()
                
                OfflineDurationSelector()
                
                Spacer()
                
                Button("CONTINUE", systemImage: K.systemArrowIcon, action: nextStage)
                .buttonStyle(FilledRedButtonStyle())
            }
            .textCase(.uppercase)
            .font(.main30)
            .multilineTextAlignment(.center)
//            .navigationDestination(isPresented: $tipsViewPresented) {
//                TipView()
//            }
            .navigationDestination(isPresented: $activitiesViewPresented) {
                ActivitiesView()
            }
            
            // TOOLBAR
            // Display the "End date" picker button
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    Button {
                        keypadInputViewShows = true
                    } label: {
                        Label("Edit duration", systemImage: "timer")
                            .labelStyle(.titleAndIcon)
                            .font(.main20)
                            .textCase(.uppercase)
                    }
                    .buttonStyle(.bordered)
                }
                
            }
            
            // SHEET FOR INPUTTING TEXT FOR THE OFFLINE TIME
            .sheet(isPresented: $keypadInputViewShows) {
                OfflineDurationKeypadInput()
                    .presentationDetents([.medium])
                    .presentationCornerRadius(35)
                    .presentationDragIndicator(.visible)
            }

        }
        
        // When the offline duration picker shows, start listening for network connectivity changes.
        
        // This allows us to check if wifi is on or off
        // That is used to determine if we should present the tips view or not, since we don't need to tell them to turn off wifi if they did already.
        .onAppear(perform: NetworkMonitor.shared.startListening)
        .onDisappear(perform: NetworkMonitor.shared.stopListening)
    }
    
    
    @ViewBuilder private func durationDisplay() -> some View {
        let timeComponents = offlineViewModel.state.durationSeconds.offlineDisplayFormatComponents(width: .abbreviated)
        
        if let firstComponent = timeComponents.first {
            Text("\(firstComponent.0)") // E.g. 9
                .textCase(.uppercase)
                .font(.display256)
                .foregroundStyle(.accent)
                .animation(.default, value: firstComponent.0) // FIX? YES // value is the number part
                .contentTransition(.numericText()) // NOT WORKING (on its own)
            
            let commaSeperatedComponents = timeComponents[1...]
                .map { "\($0.0) \($0.1)" }
                .joined(separator: ", ")
            
            Text(
                firstComponent.1 +
                (!commaSeperatedComponents.isEmpty ? ", " : "") +
                commaSeperatedComponents
            )
            
        } else {
            Text("No first component for duration. Components are \(timeComponents)")
        }
    }
    
    
    private func nextStage() {

        // If the wifi is turned on (use network monitor for this) then present the tips view sheet telling them to turn it off
//        if NetworkMonitor.shared.isConnected {
//            tipsViewPresented = true
//            
//            // tips view can navigate from there
//        }
        
        // If we have wifi turned off BUT this is the first app usage, navigate to the activities view
        if shouldShowActivitiesView {
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
