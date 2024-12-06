//
//  TipView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI
import Intents


struct TipView: View {
    
    var isFocus = INFocusStatusCenter.default.focusStatus.isFocused!
    
    var body: some View {
        
        VStack(spacing: 60) {
            
            Spacer()
            
            Label("PRO TIP", systemImage: "lightbulb.max.fill")
                .font(.display88)
                .foregroundStyle(.accent)
            
            // Display the focus symbol & text and Airplane symbol & text
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "airplane")
                        .font(.system(size: 128))
                    
                    Text("TURN ON AIRPLANE MODE")
                        .frame(maxWidth: .infinity)
                }
                
                HStack {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 128))
                    
                    Text("TURN ON FOCUS")
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.main30)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.6)
            
            Spacer()
            
            Button("OPEN SETTINGS") {
                
            }
            
            NavigationLink("CONTINUE") {
                Text("Hello, world!")
            }
            .buttonStyle(FilledRedButtonStyle())
        }
    }

}

#Preview {
    TipView()
        .environment(TipViewModel())
}
