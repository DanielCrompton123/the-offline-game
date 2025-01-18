//
//  SettingsView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var navigateToAccountCreationAgeView = false
    
    @AppStorage(K.userDefaultsUserAgeRawValueKey) private var userAgeRawValue: Int?
    
    var body: some View {
        NavigationStack {
            
            List {
                Group {
                    NavigationLink {
                        AttributionsView()
                    } label: {
                        Label("Attributions", systemImage: "hands.sparkles")
                    }
                    
                    Button("Change age", systemImage: "figure.and.child.holdinghands") {
                        navigateToAccountCreationAgeView = true
                    }
                }
                .frame(height: 50)
            }
            .font(.main20)
            .navigationTitle("Settings")
            
            .navigationDestination(isPresented: $navigateToAccountCreationAgeView) {
                AccountCreationAgeView()
                    .onChange(of: userAgeRawValue) { oldValue, newValue in
                        // We should dismiss it
                        navigateToAccountCreationAgeView = false
                    }
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
