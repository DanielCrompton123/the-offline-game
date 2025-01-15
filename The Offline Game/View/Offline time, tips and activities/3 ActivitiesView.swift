//
//  ActivitiesView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI

struct ActivitiesView: View {
    
    @Environment(ActivityViewModel.self) private var activityViewModel
    
    var body: some View {
        NavigationStack {
            
            ActivitiesListView()
                .navigationTitle("Activities")
                .toolbarTitleDisplayMode(.inline)
            
                .onAppear(perform: activityViewModel.startUpdatingActivityIcon)
                .onDisappear(perform: activityViewModel.stopUpdatingActivityIcon)
            
                // Top "Generate activity" button
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                        
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
