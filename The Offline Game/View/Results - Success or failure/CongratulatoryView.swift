//
//  CongratulatoryView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI

struct CongratulatoryView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    
    // BODY WITH GREEN BG
    var body: some View {
        ZStack {
            // GREEN BG
            LinearGradient(colors: [.green, .green.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay {
                    
                    // OFFLINE IMAGE
                    Image(.wifiBrushstrokeSlash)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 600)
                        .offset(x: 100, y: -100)
                        .foregroundStyle(.white)
                        .opacity(0.15)
                    
                }
            
            
            // CONTENT
            content
        }
        // If this view dismisses WITHOUT overtime, confirm the end offline time (by setting startDate to nil)

    }
    
    
    @ViewBuilder
    private var content: some View {
        
        VStack {
            Spacer(minLength: 0)
            
            DelayedLottieAnimation(name: "Checkmark", endCompletion: 0.8)
                .frame(height: 220)
            
            Text("You did it!")
                .font(.display108)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
            
            if let elapsedTime = offlineViewModel.state.elapsedTime {
                
                let formattedDur = elapsedTime.offlineDisplayFormat()
                
                // SUCCESS TEXT -- elapsed time
                Text("You successfully spent \(formattedDur) offline!")
                    .opacity(0.75)
                    .font(.display40)
                    .padding(.horizontal)
                
                // If the overtime duration HAS A VALUE, the user has come here from just being overtime.
                // so we should tell them
                if let overtimeElapsedTime = offlineViewModel.state.overtimeElapsedTime {
                    
                    let f = overtimeElapsedTime.offlineDisplayFormat()
                    
                    // OVERTIME LABEL
                    Text("+ \(f) overtime")
                        .font(.display40)
                    
                }
                
                // If the offlVM overtime duration is NIL the user HAS NOT been overtime.
                // So we should display a button to let them
                else {
                    
                    Spacer(minLength: 0)
                    
                    
                    // START OVERTIME BUTTON
                    Button {
                        offlineViewModel.beginOfflineOvertime(offset: 0)
                    } label: {
                        overtimeButtonLabel()
                    }
                    .tint(.white)
                    .buttonStyle(FilledRedButtonStyle())
                    
                }
                
                Spacer(minLength: 0)
                
                shareLink(formattedDuration: formattedDur)
                
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        
        // NOTE: Doing onDisappear(resetOfflineState) would not work properly.
        // RULE: With sheets, use their onDismiss instead of view onDisappear!
        // dunno why
        
    }
    

    
    @ViewBuilder private func overtimeButtonLabel() -> some View {
        VStack(spacing: 20) {
            Label {
                Text("Stay offline!")
            } icon: {
                Image(.wifiBrushstrokeSlash)
                    .resizable()
                    .scaledToFit()
            }
            .foregroundStyle(.accent)
            .font(.display40)
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "gauge.with.dots.needle.bottom.100percent")
                Text("You will get achievements for your offline overtime!")
            }
            .foregroundStyle(.smog)
            .multilineTextAlignment(.leading)
            .font(.main14)
            
        }
        .padding(.vertical)
    }
    
    
    
    @ViewBuilder private func shareLink(formattedDuration: String) -> some View {
        let congratulatoryImage = Image(.offlineCard)
        ShareLink(
            item: congratulatoryImage,
            subject: Text("I just spent \(formattedDuration) offline on the offline game!"),
            message: Text("Do you think you could beat me? Why not give it a go!"),
            preview: SharePreview("My \(formattedDuration) offline!",
                                  image: congratulatoryImage)
        ) {
            Label("Share success", systemImage: "medal.star.fill")
        }
        .buttonStyle(RedButtonStyle())
        .tint(.white)
    }
    
    
}

#Preview {
    
    let vm = {
        let vm = OfflineViewModel()
        vm.state.startDate = Date()
        vm.state.durationSeconds = .seconds(0)
        return vm
    }()
    CongratulatoryView()
        .environment(vm)
}
