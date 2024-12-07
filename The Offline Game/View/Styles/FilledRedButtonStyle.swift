//
//  FilledRedButtonStyle.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct SpacedOutLabelStyle: LabelStyle {
    var edge: HorizontalEdge = .trailing
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if edge == .trailing {
                
                Spacer(minLength: 0)
                configuration.title
                Spacer(minLength: 0)
                configuration.icon
                
            } else if edge == .leading {
                
                configuration.icon
                Spacer(minLength: 0)
                configuration.title
                Spacer(minLength: 0)
                
            }
        }
    }
    
}


#Preview("Label style") {
    Label("Hello!", systemImage: "info.circle")
        .labelStyle(SpacedOutLabelStyle(edge: .leading))
        .padding()
}


//MARK: - Button style


struct FilledRedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var edge: HorizontalEdge = .trailing
    var horizontalContentMode = ContentMode.fill
    
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .labelStyle(SpacedOutLabelStyle(edge: edge))
            .foregroundStyle(.white)
            .frame(maxWidth: horizontalContentMode == .fill ? .infinity : nil)
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .background(
                !isEnabled ? .smog : (configuration.isPressed ? .ruby : .accent),
                in: Rectangle())
            .font(.main26)
            .textCase(.uppercase)
    }
}


#Preview("Button style") {
    Button("Hello!", systemImage: "info.circle") {
        
    }
    .buttonStyle(FilledRedButtonStyle())
}
