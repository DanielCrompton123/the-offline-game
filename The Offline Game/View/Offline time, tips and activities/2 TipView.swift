//
//  TipView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


struct TipView: View {
    
    @Environment(OfflineViewModel.self) private var offlineViewModel
    @AppStorage(K.userDefaultsShouldShowActivitiesViewKey) private var shouldShowActivitiesView = true
    @State private var activitiesViewPresented = false
        
    var body: some View {
        
        VStack {
                        
            Text("PRO TIP")
                .font(.display88)
                .foregroundStyle(.accent)
            
            Spacer()
            
            // Display the focus symbol & text and Airplane symbol & text
            
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    Image(systemName: "airplane")
                        .font(.system(size: 88))
                    
                    Spacer(minLength: 0)
                    
                    Text("TURN ON AIRPLANE MODE")
                        .font(.main20)
                }
                
                HStack(spacing: 0) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 66))
                    
                    Spacer(minLength: 0)
                    
                    Text("TURN ON FOCUS")
                        .font(.main14)
                }
                .foregroundStyle(.smog)
            }
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.6)
            .padding(.horizontal)
            
            Spacer()
            
            if UIApplication.shared.canOpenURL(K.appSettingsURL) {
                Button("OPEN SETTINGS", systemImage: "gear") {
                    UIApplication.shared.open(K.appSettingsURL)
                }
                .buttonStyle(RedButtonStyle())
            }
            
            // Make ths sheet (containing duration selection and tip view) disappear and present full screen cover offline view
            Button("CONTINUE",
                   systemImage: "gear.badge.checkmark",
                   action: nextStage)
                .buttonStyle(FilledRedButtonStyle())
        }
        .navigationDestination(isPresented: $activitiesViewPresented) {
            ActivitiesView()
        }
    }
    
    // Continue the logic from the last stage (offloine duration picker view)
    // navigate to ther activities view or go offline
    private func nextStage() {
        // If we have wifi turned off BUT this is the first app usage, navigate to the activities view
        if shouldShowActivitiesView {
            activitiesViewPresented = true
            shouldShowActivitiesView = false
        }
        
        // If we don't need to see activities, just go offline
        else {
            offlineViewModel.goOffline()
        }
    }

}

#Preview {
    TipView()
        .environment(OfflineViewModel())
}
