//
//  CongratulatoryView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI
import Lottie

struct CongratulatoryView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
        
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
            
            // We can not just rely on the oldElapsedTime, because it is still nil when we present this sheet asking the user to do overtime.
//            if let elapsedTime = offlineViewModel.oldElapsedTime ?? offlineViewModel.elapsedTime {
            if let elapsedTime = offlineViewModel.state.elapsedTime {
                
                let formattedDur = elapsedTime.offlineDisplayFormat()
                
                Text("You successfully spent \(formattedDur) offline!")
                    .opacity(0.75)
                    .font(.display40)
                    .padding(.horizontal)
                
                // If the overtime duration HAS A VALUE, the user has come here from just being overtime.
                // so we should tell them
                if let overtimeElapsedTime = offlineViewModel.state.overtimeElapsedTime {
                    
                    let f = overtimeElapsedTime.offlineDisplayFormat()
                    
                    Text("+ \(f) overtime")
                        .font(.display40)
                    
                }
                
                // If the offlVM overtime duration is NIL the user HAS NOT been overtime.
                // So we should display a button to let them
                else {
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        offlineViewModel.beginOfflineOvertime(offset: 0)
                    } label: {
                        
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
                    .tint(.white)
                    .buttonStyle(FilledRedButtonStyle())
                    
                }
                
                Spacer(minLength: 0)
                
                let congratulatoryImage = Image(.offlineCard)
                ShareLink(
                    item: congratulatoryImage,
                    subject: Text("I just spent \(formattedDur) offline on the offline game!"),
                    message: Text("Do you think you could beat me? Why not give it a go!"),
                    preview: SharePreview("My \(formattedDur) offline!",
                                          image: congratulatoryImage)
                ) {
                    Label("Share success", systemImage: "medal.star.fill")
                }
                .buttonStyle(RedButtonStyle())
                .tint(.white)
                
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)

        
        // If this view dismisses WITHOUT overtime, confirm the end offline time (by setting startDate to nil)
        .onDisappear {
            print("Congrats view disappeared, in overtime?\(offlineViewModel.isInOvertime)")
            if !offlineViewModel.isInOvertime {
                #warning("!offlineViewModel.isInOvertime")
                print("Not in overtime so confirming offline time finished...")
                offlineViewModel.confirmOfflineTimeFinished()
            }
        }
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
