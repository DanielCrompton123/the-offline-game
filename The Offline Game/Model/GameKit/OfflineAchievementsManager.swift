//
//  OfflineAchievementsManager.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/11/25.
//

import SwiftUI


// Responsible for managing progress replated to different achievements.
class OfflineAchievementsProgressManager {
    
    //MARK: - Singleton
    private init() { }
    static let shared = OfflineAchievementsProgressManager()
    
    
    //MARK: - Stored data
    
    @AppStorage("numOffPds") private var numOfflinePeriods: Int = 0
//    @AppStorage("firstOfflineTimeSecs") private var firstOfflineTimeSecs: Double = 0
//    @AppStorage("totalOfflineTimeSecs") private var totalOfflineTimeSecs: Double = 0
//    @AppStorage("totalOvertimeSecs") private var totalOvertimeSecs: Double = 0
//    @AppStorage("previousDaysRunning") private var previousDaysRunning: Int = 0
    
    
    // Returns a filtered list of achievements depending on an event that occurred
    func getAchievements(for event: GameEvent) -> [OfflineAchievement] {
        
        return switch event {
            
        case .offlineTimeFinished: [
            .periods(num: 5), .periods(num: 10), .periods(num: 50)
        ]
            
        case .overtimeFinished: [
//            .overtime(mins: 30), .overtime(mins: 2 * 60), .overtime(mins: 5 * 60)
        ]
            
        case .appOpened: [
            
        ]
        }
        
    }
    
    
    // Updates stored data used to calculate the progress for an achievemnt
    func updateProperties(for achievement: OfflineAchievement, event: GameEvent) {
        
//        switch event {
//        case .offlineTimeFinished(let successful, let duration):
//            if successful {
//                numOfflinePeriods += 1
//            }
//            
//        case .overtimeFinished(let duration):
//            break
//        case .appOpened:
//            break
//        }
        
        switch achievement {
        case .periods:
            numOfflinePeriods += 1
            
        default: break
        }
        
    }
    
    
    func getProgress(towards achievement: OfflineAchievement, event: GameEvent) -> Double {
        
        switch achievement {
        
        case .periods(let num):
            Double(numOfflinePeriods) / Double(num)
            
        default: 0.0
        }
        
    }
    
    
    
    // Uses a parameter injection for the achievement ViewModel.
    // Uses the other functions to update the achievement's progress for a particular event
    func handle(event: GameEvent, achievementViewModel: GameKitAchievementsViewModel) {
        
        // 1. Get the achievements that are associated with a particular event
        let achievements = getAchievements(for: event)
        
        // 2. Now, we want to take the first achievement of its type, (e.g. [.firstMins(10), .firstMins(30)....] and update the progress for it -- this updates the variables that will be used in calculating the progress
        var updatedAchievementTypes: Set<OfflineAchievement.AchievementType> = []
        
        achievements.forEach { ach in
            if !updatedAchievementTypes.contains(ach.type) {
                updateProperties(for: ach, event: event)
                updatedAchievementTypes.insert(ach.type)
            }
        }
        
        // 3. Now we can take each of the achievements and get the progress towards it. then register with tha achievementVM
        achievements.forEach { ach in
            // Max value is 100
            let achProg = min(
                getProgress(towards: ach, event: event) * 100,
                100
            )
            
            achievementViewModel.reportProgress(achProg, for: ach)
        }
    }
    
    
    func resetAchievementProgress() {
        // Reset the state properties
        numOfflinePeriods = 0
    }
}
