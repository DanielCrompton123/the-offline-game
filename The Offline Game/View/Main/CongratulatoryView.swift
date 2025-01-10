//
//  CongratulatoryView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI

struct CongratulatoryView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    var body: some View {
        ZStack {
            // GREEN BG
            Color.green
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
            
            Image(systemName: "checkmark")
                .font(.system(size: 130, weight: .black))
                .foregroundStyle(.green.gradient)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 10, y: 10)
            
            Text("You did it!")
                .font(.display108)
            
            let formattedDur = DurationDisplayHelper.formatDuration(offlineViewModel.durationSeconds)
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
            
            Spacer()
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
