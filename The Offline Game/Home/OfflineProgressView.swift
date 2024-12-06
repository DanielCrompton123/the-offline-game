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
                
        if let timeRemainingString = offlineViewModel.timeRemainingString {
            Text(timeRemainingString)
                .font(.display88)
                .foregroundStyle(.white)
        }
        
    }
    
}

#Preview {
    OfflineProgressView(progress: 0.01)
        .environment(OfflineViewModel())
        .padding()
}
