//
//  FilledRedButtonStyle.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


struct SpacedOutLabelStyle: LabelStyle {
    var edge: HorizontalEdge = .trailing
    var spacedOut = true
    
    func makeBody(configuration: Configuration) -> some View {        
        let alignment = edge == .leading ? Alignment.leading : Alignment.trailing
        
        if spacedOut {
            configuration.title
                .frame(maxWidth: .infinity) // infinity because we are spaced out
                .overlay(alignment: alignment) {
                    configuration.icon
                }
        } else {
            HStack {
                if edge == .trailing {
                    configuration.title
                    configuration.icon
                } else {
                    configuration.icon
                    configuration.title
                }
            }
        }
    }
    
}


//MARK: - Button style


struct FilledRedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var edge: HorizontalEdge = .trailing
    var horizontalContentMode = ContentMode.fill
    
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .labelStyle(SpacedOutLabelStyle(edge: edge, spacedOut: horizontalContentMode == .fill))
            .foregroundStyle(.white)
            .frame(maxWidth: horizontalContentMode == .fill ? .infinity : nil) // applied by label style BUT we may or may not have an icon so we apply it here too
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .background(
                !isEnabled ? .smog : (configuration.isPressed ? .ruby : .accent),
                in: Rectangle())
            .font(.main26)
            .textCase(.uppercase)
    }
}


struct RedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    var edge = HorizontalEdge.trailing
    var horizontalContentMode = ContentMode.fill
        
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .foregroundStyle(
                !isEnabled ? .smog : (configuration.isPressed ? .ruby : .accent)
            )
            .labelStyle(SpacedOutLabelStyle(edge: edge, spacedOut: horizontalContentMode == .fill))
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .font(.main26)
            .textCase(.uppercase)
    }
}





#Preview("Filled red") {
    Button("Hello!", systemImage: "info.circle") {}
        .buttonStyle(FilledRedButtonStyle(edge: .leading, horizontalContentMode: .fit))
}


#Preview("Red") {
    Button("Hello!", systemImage: "info.circle") { }
        .buttonStyle(RedButtonStyle(edge: .leading))
//    .disabled(true)
}
