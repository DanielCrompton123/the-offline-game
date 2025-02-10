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
        }

    }
}



#Preview("DEBUG") {
    DEBUG()
}

