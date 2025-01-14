//
//  ActivitiesView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI

struct ActivitiesView: View {
    
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    @State private var error = ""
    
    var body: some View {
        NavigationStack {
            
            ActivitiesListView()
                .navigationTitle("Activities")
                .toolbarTitleDisplayMode(.inline)
            
                .onAppear(perform: activityViewModel.startUpdatingActivityIcon)
                .onDisappear(perform: activityViewModel.stopUpdatingActivityIcon)
            
                // Top "Generate activity" button
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .top) {
                    ZStack(alignment: .bottom) {
                        Button(
                            "Generate activity",
                            systemImage: activityViewModel.activityIcon,
                            action: loadBoredActivity
                        )
                        .disabled(activityViewModel.isFetchingBoredActivity)
                        .buttonStyle(RedButtonStyle())
//                        .padding(.horizontal)
//                        .padding(.bottom)
                        .background(.bar)
                        
                        Divider()
                    }
                }
            
                // Error alert for bored API activities
                .alert("Error getting Bored activity", isPresented: $error.condition(\.isEmpty, inverse: true)) {
                    Button("OK", role: .cancel) {
                        error = ""
                    }
                } message: {
                    Text(error)
                }
            
        }
    }
    
    
    private func loadBoredActivity() {
        Task {
            do {
                try await activityViewModel.getBoredActivity()
            } catch {
                print("Error getting bored activity: \(error)")
                self.error = error.localizedDescription
            }
        }
    }
}

#Preview {
    ActivitiesView()
        .environment(ActivityViewModel())
    
        .safeAreaInset(edge: .bottom) {
            ZStack(alignment: .top) {
                Button("Go offline") { }
                    .buttonStyle(FilledRedButtonStyle())
                    .padding()
                    .background(.bar)
                
                Divider()
            }
        }
}
