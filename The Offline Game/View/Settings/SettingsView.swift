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
                    
//                    Button("Change age", systemImage: "figure.and.child.holdinghands") {
//                        navigateToAccountCreationAgeView = true
//                    }
                    NavigationLink(
                        destination: AccountCreationAgeView {
                            navigateToAccountCreationAgeView = false
                        },
                        isActive: $navigateToAccountCreationAgeView
                    ) {
                        Label("Change age", systemImage: "figure.and.child.holdinghands")
                    }
                }
                .frame(height: 50)
            }
            .font(.main20)
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    SettingsView()
}
