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
        await MainActor.run {
            isFetchingBoredActivity = true
        }

        do {
            let activity = try await RequestsManager.get(
                K.boredAPIEndpoint,
                decodeTo: BoredActivity.self
            )
            
            await MainActor.run {
                boredActivities.insert(activity, at: 0)
                isFetchingBoredActivity = false
            }

        } catch {
            await MainActor.run {
                isFetchingBoredActivity = false
            }
            throw error
        }
    }
    
    
    func startUpdatingActivityIcon(timeInterval: TimeInterval) {
        Timer.publish(every: timeInterval, on: RunLoop.main, in: RunLoop.Mode.common)
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
