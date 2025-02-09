//
//  DEBUG_ENTRY.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI


struct DEBUG: View {

    @State private var value = 1.0
    var body: some View {
        
        VStack(spacing: 30) {
            
            Circle()
                .frame(width: 20, height: 20)
            
            
            
            SteppedSlider(value: $value, properties: [
                .init(range: 0.0...25.0, spacing: 20, step: 1, color: .red),
                .init(range: 25.0...50.0, spacing: 30, step: 5, color: .blue),
                .init(range: 50.0...100.0, spacing: 50, step: 10, color: .pink)
            ])
            .frame(height: 50)
        }

    }
}



#Preview("DEBUG") {
    DEBUG()
}

