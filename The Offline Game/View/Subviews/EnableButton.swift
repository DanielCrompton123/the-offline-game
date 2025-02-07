//
//  EnableButton.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import SwiftUI

struct EnableButton: View {
    
    let text: String
    var systemImage: String? = nil
    var role: ButtonRole? = nil
    let action: () -> ()
    
    var body: some View {
        
        if let systemImage {
            Button(text, systemImage: systemImage, role: role, action: onButtonClick)
        }
    }
    
    
    
    private func onButtonClick() {
        action()
    }
    
    
}

#Preview {
    EnableButton(text: "Press me") {
        
    }
}
