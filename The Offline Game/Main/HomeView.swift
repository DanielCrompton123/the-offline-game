//
//  HomeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(OfflineViewModel.self) private var offlineViewModel
    
    @State private var offlineSliderViewPresented = false
    
    var body: some View {
        
        @Bindable var offlineViewModel = offlineViewModel
        
        NavigationStack(path: $offlineViewModel.navigation) {
            VStack {
                
                Spacer()
                
                OfflineHeader()
                
                Spacer()
                
                Text("\(Text("2,571").foregroundStyle(.ruby)) people are offline right now, competing to see who can avoid their phone the longest.\n\(Text("Up for the challenge?").foregroundStyle(colorScheme == .light ? .black : .white))")
                    .textCase(.uppercase)
                    .font(.main20)
                    .foregroundStyle(.smog)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button("GO OFFLINE") {
                    offlineSliderViewPresented = true
                }
                .buttonStyle(FilledRedButtonStyle())
                
                Spacer()
            }
            .sheet(isPresented: $offlineSliderViewPresented) {
                OfflineTimeView()
            }
            .navigationDestination(for: NavigationStep.self, destination: { step in
                switch step {
                case .home:
                    EmptyView()
                case .offline:
                    OfflineView()
                }
            })
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    HomeView()
        .environment(OfflineViewModel())
}
