//
//  OfflineView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI



struct OfflineView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var showActivitiesView = false
    
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
                    
                    OfflineProgressView()
                    
                    Text("I'm offline")
                        .font(.display88)
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Button("WHAT TO DO?", systemImage: activityViewModel.activityIcon) {
                        showActivitiesView = true
                    }
                    .buttonStyle(RedButtonStyle())
                    .onAppear(perform: activityViewModel.startUpdatingActivityIcon)
                    .onDisappear(perform: activityViewModel.stopUpdatingActivityIcon)
                    
                    Button("GO ONLINE") {
                        offlineViewModel.offlineTimeFinished(successfully: true)
                    }
                    .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
    
                }
                .padding(.horizontal)
                
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .sheet(isPresented: $showActivitiesView) {
                ActivitiesView()
            }
    }

}

#Preview {
    OfflineView()
}
