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
        let alignment = edge == .leading ? Alignment.leading : Alignment.trailing
        
        configuration.title
            .frame(maxWidth: .infinity)
            .overlay(alignment: alignment) {
                configuration.icon
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


struct RedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
        
    func makeBody(configuration: Configuration) -> some View {
        
        return configuration.label
            .foregroundStyle(
                !isEnabled ? .smog : (configuration.isPressed ? .ruby : .accent)
            )
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .font(.main26)
            .textCase(.uppercase)
    }
}





#Preview("Filled red") {
    Button("Hello!", systemImage: "info.circle") {}
    .buttonStyle(FilledRedButtonStyle())
}


#Preview("Red") {
    Button("Hello!", systemImage: "info.circle") { }
    .buttonStyle(RedButtonStyle())
//    .disabled(true)
}
