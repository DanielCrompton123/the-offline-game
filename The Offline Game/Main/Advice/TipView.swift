//
//  TipView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI

fileprivate enum TipPhase {
    case airplaneMode, focus
    
    func next() -> TipPhase {
        switch self {
        case .airplaneMode:
                .focus
        case .focus:
                .airplaneMode
        }
    }
    
    var icon: String {
        switch self {
        case .airplaneMode:
            "airplane"
        case .focus:
            "moon.fill"
        }
    }
    
    var label: String {
        switch self {
        case .airplaneMode:
            "Turn on airplane mode"
        case .focus:
            "Turn on focus"
        }
    }
    
    var url: URL {
        switch self {
        case .airplaneMode:
            URL(string: "App-Prefs:root=AIRPLANE_MODE")!
        case .focus:
            URL(string: "App-Prefs:root=DO_NOT_DISTURB")!
        }
    }
        
    @ViewBuilder
    var button: some View {
        if UIApplication.shared.canOpenURL(url) {
            Button("OPEN IN SETTINGS") {
                UIApplication.shared.open(url)
            }
        }
    }
}


struct TipView: View {
    @State private var phase = TipPhase.airplaneMode
    
    var body: some View {
        VStack(spacing: 60) {
            
            Spacer()
            
            Label("PRO TIP", systemImage: "lightbulb.max.fill")
                .font(.display88)
                .foregroundStyle(.accent)
            
            VStack(spacing: 20) {
                Image(systemName: phase.icon)
                    .font(.system(size: 128))
                
                Text(phase.label)
                    .font(.main26)
            }
            .textCase(.uppercase)
            
            Spacer()
            
            VStack {
                phase.button
                
                Button("CONTINUE") {
                    phase = phase.next()
                }
            }
            .buttonStyle(FilledRedButtonStyle())
        }
    }

}

#Preview {
    TipView()
}
