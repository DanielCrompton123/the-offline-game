//
//  FilledRedButtonStyle.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct FilledRedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .background(configuration.isPressed ? .ruby : .accent, in: Rectangle())
            .font(.main26)
    }
}
