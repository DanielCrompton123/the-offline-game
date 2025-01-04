//
//  ActivitiesView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import SwiftUI

struct ActivitiesView: View {
    
    @Environment(ActivityViewModel.self) private var activityViewModel
    @State private var newActivityIcon = "figure.walk.motion"
    
    @State private var error = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if let preloadedActivities = activityViewModel.preloadedActivities {
                    
                    List {
                        
                        if !activityViewModel.boredActivities.isEmpty {
                            
                            Section {
                                
                                ForEach(activityViewModel.boredActivities) { activity in
                                    boredActivityListRow(activity)
                                    }
                                
                                Button("Clear", systemImage: "xmark.octagon", role: .destructive) {
                                    activityViewModel.boredActivities.removeAll()
                                }
                                
                            } header: {
                                Label("Your activities", systemImage: "figure.wave")
                                    .font(.headline)
                            }
                            
                        }
                        
                        ForEach(preloadedActivities) { activityCollection in
                            
                            Section {
                                ForEach(activityCollection.activities) { activity in
                                    activityListRow(activity)
                                    
                                }
                            } header: {
                                Label(activityCollection.category, systemImage: activityCollection.systemImage)
                                    .font(.headline)
                            }
                            
                        }
                    }
                    
                } else {
                    ContentUnavailableView("No preloaded activities yet...", systemImage: "questionmark")
                }
            }
            .onAppear(perform: activityViewModel.loadPreloadedActivities)
            .onAppear(perform: loadNewActivityIcon)
            .navigationTitle("Activities")
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                ZStackLayout(alignment: .bottom) {
                    Button("Generate activity", systemImage: newActivityIcon, action: loadBoredActivity)
                        .disabled(activityViewModel.isFetchingBoredActivity)
                    .buttonStyle(FilledRedButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                    .background(.bar)
                    
                    Divider()
                }
            }
            .alert("Error getting Bored activity", isPresented: $error.condition(\.isEmpty, inverse: true)) {
                Button("OK", role: .cancel) {
                    error = ""
                }
            } message: {
                Text(error)
            }

        }
    }
    
    
    @ViewBuilder private func activityListRow(_ activity: PreloadedActivityCollection.Activity) -> some View {
        VStack(alignment: .leading) {
            Text(activity.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .bold()
            
            Text(activity.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
        }
        .padding(.vertical, 5)
    }
    
    
    @ViewBuilder private func boredActivityListRow(_ activity: BoredActivity) -> some View {
        HStack {
            HStack {
                Image(systemName: activity.systemImage)
                Text(activity.activity)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.callout)
            .bold()
            
            // Participants
            Text("\(activity.participants)")
                .font(.caption)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.smog, in: .capsule)
            

        }
        .padding(.vertical, 5)
    }
    
    
    private func loadNewActivityIcon() {
        self.newActivityIcon = K.activityIcons.randomElement()!
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
