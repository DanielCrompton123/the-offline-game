//
//  FilledRedButtonStyle.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct FilledRedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var horizontalContentMode = ContentMode.fill
    var verticalContentMode = ContentMode.fit
    
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .foregroundStyle(.white)
            .frame(maxWidth: horizontalContentMode == .fill ? .infinity : nil)
            .frame(maxHeight: verticalContentMode == .fill ? .infinity : nil)
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .background(
                !isEnabled ? .smog : (configuration.isPressed ? .ruby : .accent),
                in: Rectangle())
            .font(.main26)
    }
}
