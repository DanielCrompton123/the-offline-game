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
        VStack(spacing: 30) {
            Spacer()
            
            DelayedLottieAnimation(name: "Checkmark", endCompletion: 0.8)
                .frame(height: 220)
            
            Text("You did it!")
                .font(.display108)
            
            if let elapsedTime = offlineViewModel.state.oldElapsedTime {
                let formattedDur = Duration.seconds(elapsedTime).offlineDisplayFormat()
                
                Text("You successfully spent \(formattedDur) offline!")
                    .opacity(0.75)
                    .font(.display40)
                
                Spacer()
                
                let congratulatoryImage = Image(.offlineCard)
                ShareLink(
                    item: congratulatoryImage,
                    subject: Text("I just spent \(formattedDur) offline on the offline game!"),
                    message: Text("Do you think you could beat me? Why not give it a go!"),
                    preview: SharePreview("My \(formattedDur) offline!",
                                          image: congratulatoryImage)
                ) {
                    Label("Share success", systemImage: "medal.star.fill")
                        .foregroundStyle(.green)
                }
                .buttonStyle(FilledRedButtonStyle())
                .tint(.white)
                .padding(.horizontal, -40) // opposite of the padding added by the stack
                
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
}

#Preview {
    CongratulatoryView()
        .environment(OfflineViewModel())
}
