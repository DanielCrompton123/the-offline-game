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
        
        VStack(spacing: 20) {
            
            Spacer()
            
            VStack {
                DelayedLottieAnimation(name: "Lightbulb", endCompletion: 0.9, delay: 0)
                    .frame(height: 120)
                    .scaleEffect(1.6)
                
                Text("PRO TIP")
                    .font(.display88)
                    .foregroundStyle(.accent)
            }
            
            Spacer()
            
            VStack {
                // Display the focus symbol & text and Airplane symbol & text
                tip(image: .plane, title: "Turn on airplane mode", alignment: .topLeading)
                tip(image: .moon, title: "Turn on focus", alignment: .topTrailing)
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
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
        }
        .navigationDestination(isPresented: $activitiesViewPresented) {
            ActivitiesView()
                .safeAreaInset(edge: .bottom) {
                    ZStack(alignment: .top) {
                        Button("Go offline", action: offlineViewModel.goOffline)
                            .buttonStyle(FilledRedButtonStyle())
                            .padding()
                            .background(.bar)
                        
                        Divider()
                    }
                }
        }
    }
    
    
    // Draw the tip -- i.e. icon with text on top
    @ViewBuilder private func tip(image: ImageResource, title: String, alignment: Alignment = .center) -> some View {
        Text(title)
            .font(.main26)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.smog.opacity(0.4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            }
    }
    
    
    // Continue the logic from the last stage (offline duration picker view)
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
    NavigationStack {
        TipView()
            .environment(OfflineViewModel())
    }
}
