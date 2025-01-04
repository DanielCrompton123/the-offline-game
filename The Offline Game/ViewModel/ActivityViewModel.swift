//
//  ActivityViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import Foundation

@Observable
class ActivityViewModel {
    var preloadedActivities: [PreloadedActivityCollection]?
    var boredActivities: [BoredActivity] = []
    
    var isFetchingBoredActivity = false
    
    
    func loadPreloadedActivities() {
        do {
            // Load the data for the activities.json
            guard let url = Bundle.main.url(forResource: "activities", withExtension: "json") else {
                print("Couldn't find URl for activities.json")
                return
            }
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            preloadedActivities = try decoder.decode([PreloadedActivityCollection].self, from: data)
        } catch {
            print("Error decoding activities.json: \(error)")
        }
    }
    
    
    func getBoredActivity() async throws {
        guard let url = URL(string: K.boredAPIEndpoint) else {
            print("Cannot make a URl from '\(K.boredAPIEndpoint)'")
            throw URLError(.badURL)
        }
        
        await MainActor.run {
            isFetchingBoredActivity = true
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        let activity = try decoder.decode(BoredActivity.self, from: data)
        
        await MainActor.run {
            boredActivities.insert(activity, at: 0)
            
            isFetchingBoredActivity = false
        }
    }
    
}
