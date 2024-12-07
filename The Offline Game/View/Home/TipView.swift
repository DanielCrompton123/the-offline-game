//
//  TipView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI
import Intents


struct TipView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    private let settingsURL = URL(string: UIApplication.openSettingsURLString)! // force unwrapping a system property in a variable
    
    private let iconFont = Font.system(size: 88)
        
    var body: some View {
        
        VStack {
                        
            Text("PRO TIP")
                .font(.display88)
                .foregroundStyle(.accent)
            
            Spacer()
            
            // Display the focus symbol & text and Airplane symbol & text
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "airplane")
                        .font(iconFont)
                    
                    Text("TURN ON AIRPLANE MODE")
                        .frame(maxWidth: .infinity)
                }
                
                HStack {
                    Image(systemName: "moon.fill")
                        .font(iconFont)
                    
                    Text("TURN ON FOCUS")
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.main20)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.6)
            
            Spacer()
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                Button("OPEN SETTINGS") {
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            // Make ths sheet (containing duration selection and tip view) disappear and present full screen cover offline view
            Button("I'M READY!", action: startOffline)
                .buttonStyle(FilledRedButtonStyle())
        }
        .onAppear {
            print("Settings URL = \(settingsURL.relativePath)")
        }
    }
    
    private func startOffline() {
        offlineViewModel.isPickingDuration = false
        offlineViewModel.goOffline()
    }
    

}

#Preview {
    TipView()
}
