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
    @AppStorage("totalOfflineTimeSecs") private var totalOfflineTimeSecs: Double = 0
    @AppStorage("totalOvertimeSecs") private var totalOvertimeSecs: Double = 0
//    @AppStorage("previousDaysRunning") private var previousDaysRunning: Int = 0
    
    
    // Returns a filtered list of achievements depending on an event that occurred
    func getAchievements(for event: GameEvent) -> [OfflineAchievement] {
        
        return switch event {
            
        case .offlineTimeFinished: [
            .periods(num: 5), .periods(num: 10), .periods(num: 50),
            
            .total(hrs: 1), .total(hrs: 2), .total(hrs: 5), .total(hrs: 10), .total(hrs: 15), .total(hrs: 20), .total(hrs: 50), .total(hrs: 100)
        ]
            
        case .overtimeFinished: [
            .overtime(mins: 30), .overtime(mins: 2 * 60), .overtime(mins: 5 * 60),
            
            .total(hrs: 1), .total(hrs: 2), .total(hrs: 5), .total(hrs: 10), .total(hrs: 15), .total(hrs: 20), .total(hrs: 50), .total(hrs: 100)
        ]
            
        case .appOpened: [
            
        ]
        }
        
    }
    
    
    // Updates stored data used to calculate the progress for an achievemnt
    func updateProperties(for achievement: OfflineAchievement, event: GameEvent) {
                
        switch achievement {
        case .periods:
            numOfflinePeriods += 1
            
        case .total:
            switch event {
            case .offlineTimeFinished(_, let secs),
                    .overtimeFinished(let secs):
                totalOfflineTimeSecs += Double(secs.components.seconds)
            default: break
            }
            
        case .overtime:
            switch event {
            case .overtimeFinished(let duration):
                totalOvertimeSecs += Double(duration.components.seconds)
            default: break
            }
            
        default: break
        }
        
    }
    
    
    func getProgress(towards achievement: OfflineAchievement, event: GameEvent) -> Double {
        
        switch achievement {
        
        case .periods(let num):
            Double(numOfflinePeriods) / Double(num)
            
        case .total(hrs: let hours):
            {
                let secs = Double(hours * 60 * 60)
                return totalOfflineTimeSecs / secs
                // E.g. 10 / (1 * 60 * 60)
            }()
            
        case .overtime(mins: let mins):
            {
                let secs = Double(mins * 60)
                return totalOvertimeSecs / secs
                // E.g. 1hr,10m / 30m = 70/30 = 2.33
            }()
            
        default:
            0.0
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
            let achProg = getProgress(towards: ach, event: event) * 100
            
            achievementViewModel.reportProgress(achProg, for: ach)
        }
    }
    
    #warning("ADD PROPERTIES IN resetAchievementProgress")
    func resetAchievementProgress() {
        // Reset the state properties
        numOfflinePeriods = 0
        totalOfflineTimeSecs = 0
        totalOvertimeSecs = 0
    }
}
