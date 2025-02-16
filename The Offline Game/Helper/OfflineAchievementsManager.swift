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
    @AppStorage("firstOfflineTimeSecs") private var firstOfflineTimeSecs: Double = 0
    @AppStorage("totalOfflineTimeSecs") private var totalOfflineTimeSecs: Double = 0
    @AppStorage("totalOvertimeSecs") private var totalOvertimeSecs: Double = 0
    @AppStorage("daysRunning") private var daysRunning: Int = 0
    @AppStorage("lastOpenDate") private var lastOpenDate: Date?
    
    
    // Returns a filtered list of achievements depending on an event that occurred
    func getAchievements(for event: GameEvent) -> [OfflineAchievement] {
        
        return switch event {
            
        case .offlineTimeFinished: [
            .periods(num: 5), .periods(num: 10), .periods(num: 50),
            
            .total(hrs: 1), .total(hrs: 2), .total(hrs: 5), .total(hrs: 10), .total(hrs: 15), .total(hrs: 20), .total(hrs: 50), .total(hrs: 100),
            
            .block(hrs: 1), .block(hrs: 2), .block(hrs: 5), .block(hrs: 10), .block(hrs: 15), .block(hrs: 20), .block(hrs: 24), .block(hrs: 36),
            
            .firstMins(mins: 10), .firstMins(mins: 30)
        ]
            
        case .overtimeFinished: [
            .overtime(mins: 30), .overtime(mins: 2 * 60), .overtime(mins: 5 * 60),
            
            .total(hrs: 1), .total(hrs: 2), .total(hrs: 5), .total(hrs: 10), .total(hrs: 15), .total(hrs: 20), .total(hrs: 50), .total(hrs: 100),
            
            .block(hrs: 1), .block(hrs: 2), .block(hrs: 5), .block(hrs: 10), .block(hrs: 15), .block(hrs: 20), .block(hrs: 24), .block(hrs: 36),
            
            .firstMins(mins: 10), .firstMins(mins: 30)
        ]
            
        case .appOpened: [
            .daysRunning(num: 2), .daysRunning(num: 7)
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
            
        case .firstMins:
            switch event {
            case .offlineTimeFinished(_, let secs),
                    .overtimeFinished(let secs):
                firstOfflineTimeSecs += Double(secs.components.seconds)
            default: break
            }
            
        case .daysRunning:
            // If the app is opening for the first time, the last open date is nil,
            // So we know to add 1 to the days running and set the date
            guard let lastOpenDate else {
                lastOpenDate = Date()
                daysRunning += 1
                return
            }
            
            // If the app was opened yesterday, (the user is opening it again now), add 1 to the daysRunning and also set the last open date
            if Calendar.current.isDateInYesterday(lastOpenDate) {
                self.lastOpenDate = Date()
                daysRunning += 1
            }
            
            // If it was NOT opened yesterday, and the date has a value, this is the first in their streak so set it to 1
            else if !Calendar.current.isDateInToday(lastOpenDate) {
                daysRunning = 1
            }
            
            // This makes sure that the daysrunning isn't updated is opening multiple times in a day
            
        default: break // including .block -- nothing to update for block
            
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
            
        case .block(hrs: let hours):
            {
                let blockSecs = Double(hours * 60 * 60)
                // The user has either FULLY ACHIEVED OR NOT ACHIEVED the block
                
                let duration: Duration? = {
                    if case let .offlineTimeFinished(_, duration) = event {
                        return duration
                    } else if case let .overtimeFinished(duration) = event {
                        return duration
                    }
                    return nil
                }()
                
                
                if let duration {
                    return duration.seconds >= blockSecs ? 1.0 : 0.0
                } else {
                    return 0.0
                }
            }()
            
        case .overtime(mins: let mins):
            {
                let secs = Double(mins * 60)
                return totalOvertimeSecs / secs
                // E.g. 1hr,10m / 30m = 70/30 = 2.33
            }()
            
        case .firstMins(mins: let mins):
            {
                let secs = Double(mins * 60)
                return firstOfflineTimeSecs / secs
            }()
            
        case .daysRunning(num: let num):
            Double(daysRunning) / Double(num)
            
        default:
            0.0
        }
        
    }
    
    
    
    // Uses a parameter injection for the achievement ViewModel.
    // Uses the other functions to update the achievement's progress for a particular event
    func handle(event: GameEvent, achievementViewModel: GameKitAchievementsViewModel) async {
        
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
        for ach in achievements {
            let achProg = getProgress(towards: ach, event: event) * 100
            
            await achievementViewModel.reportProgress(achProg, for: ach)
        }
    }
    
    func resetAchievementProgress() {
        // Reset the state properties
        numOfflinePeriods = 0
        firstOfflineTimeSecs = 0
        totalOfflineTimeSecs = 0
        totalOvertimeSecs = 0
        daysRunning = 0
        lastOpenDate = Date()
    }
}
