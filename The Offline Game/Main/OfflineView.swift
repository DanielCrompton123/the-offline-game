//
//  OfflineView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI

struct OfflineView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            
            Color.accentColor
                .ignoresSafeArea()
            
            LinearGradient(colors: [.ruby, .clear, .ruby.opacity(0.75)], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            VStack {
                Text("DO NOT DISTURB")
                    .frame(maxWidth: 300) // forces text into 2 lines
                    .multilineTextAlignment(.center)
                    .font(.main54)
                
                Spacer()
                
                OfflineProgressView(progress: 0.01)
                
                Text("I'm offline")
                    .font(.display88)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button("GO ONLINE") {
                    
                }
                .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
            }
            .padding(.horizontal)
            
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    OfflineView()
}
