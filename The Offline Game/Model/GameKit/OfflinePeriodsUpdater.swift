//
//  OfflinePeriodsUpdater.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/22/25.
//

import Foundation
import SwiftUI


// Responsible for reporting progress for achievements related to the NUMBER OF OFFLINE PERIODS the user has done, not necessarilly the actual offline time.


class OfflinePeriodsUpdater: AchievementUpdater {
    
    private init() { }
    
    static let shared = OfflinePeriodsUpdater()
    
    
    
    @AppStorage("numOffPds") private var numOfflinePeriods: Int = 0
    
    
    
    func achievements(for event: GameEvent) -> [OfflineAchievement] {
        
        var achievements = [OfflineAchievement]()
        
        
        switch event {
        case .offlineTimeFinished(_, let duration):
            
            // Here, only give the relevant achievements if the offline duration is in the correct range:
            // Only add progress towards achievemnts if they spent at least 10 minutes offline.
            
            // EDIT:
            
            // That is done in the progress(for:) -- progress is returned as 0 if they shouldn't get the achievement.
            // Therefore here, we can just retrieve ALL of them

//            #if DEBUG
            achievements.append(contentsOf: [.periods(num: 5), .periods(num: 10), .periods(num: 50)])
//            #else
//            if duration.components.seconds > 600 { // 600 = 10 mins
//                achievements.append(contentsOf: [.periods(num: 5), .periods(num: 10), .periods(num: 50)])
//            }
//            #endif
//            
            
        default: break
        }
        
        
        return achievements
    }
    

    func updateProgress(for event: GameEvent) {
        numOfflinePeriods += 1
    }
    
    
    func progress(for achievement: OfflineAchievement) -> Double? {
        
        switch achievement {
        case .periods(let num):
            return min(Double(numOfflinePeriods) / Double(num), 1)
            
        default:
            return nil
        }
    }
    

    func resetAllProgress() {
        // Reset the numOfflinePeriods variable to 0, in user defaults
        numOfflinePeriods = 0
    }
}
