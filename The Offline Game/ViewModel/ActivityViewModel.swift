//
//  ActivityViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import Foundation
import Combine

@Observable
class ActivityViewModel {
    var preloadedActivities: [PreloadedActivityCollection]?
    var boredActivities: [BoredActivity] = []
    
    var activityIcon = "figure.walk.motion"
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        #warning("TODO: Use request helper inside of getBoredActivity.")
        guard let url = URL(string: K.boredAPIEndpoint) else {
            print("Cannot make a URL from '\(K.boredAPIEndpoint)'")
            throw URLError(.badURL)
        }
        
        await MainActor.run {
            isFetchingBoredActivity = true
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        do {
            let activity = try decoder.decode(BoredActivity.self, from: data)
            
            await MainActor.run {
                boredActivities.insert(activity, at: 0)
            }
        } catch {
            isFetchingBoredActivity = false
            throw error
        }
    }
    
    
    #warning("TODO: Add interval parameter")
    func startUpdatingActivityIcon() {
        Timer.publish(every: K.activityIconChangeInterval, on: RunLoop.main, in: RunLoop.Mode.common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.activityIcon = K.activityIcons.randomElement()!
            }
            .store(in: &cancellables)
    }
    
    func stopUpdatingActivityIcon() {
        cancellables.removeAll()
    }
    
}
