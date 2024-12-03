//
//  OfflineProgressView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/3/24.
//

import SwiftUI

struct OfflineProgressView: View {
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    var progress: CGFloat
    
    var body: some View {
        
        // Display a circular prograss indicator
        ZStack {
            // background filled with the secondary color
            Circle()
                .stroke(.secondary, lineWidth: 25)
            
            // foreground (filled) part
            Circle()
                .trim(to: progress) // Clip the path
                .stroke(.primary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        
    }
}

#Preview {
    OfflineProgressView(progress: 0.01)
        .environment(OfflineViewModel())
        .padding()
}
