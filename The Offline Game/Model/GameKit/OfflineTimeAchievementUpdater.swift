//
//  OfflineTimeAchievementUpdater.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import Foundation
import SwiftUI

class OfflineTimeAchievementUpdater: AchievementUpdater {
    
    private init() { }
    
    static let shared = OfflineTimeAchievementUpdater()
    
    
    //MARK: - Store values
    
    // Total offline time in minutes (We don't need to have as much accuracy as double)
    @AppStorage("totalOfflineMins") private var totalOfflineMins: Int = 0
    
    
    //MARK: - Achievement Updater
    
    func achievements(for event: GameEvent) -> [OfflineAchievement] {
        
        var achievements = [OfflineAchievement]()
        
        switch event {
        case .offlineTimeFinished(let successful, _):
            
            // Your first 10 / 30 minutes IF they went offline for this

            // Here, we DO NOT need to refine the achievements to those within the duration
            // e.g. filtering first10Mins/30Mins to higher values than the duration is UNNECESSARY because the progress(for) will just get progress as 0 if the user didn't achieve it.
            achievements.append(.firstMins(mins: 10))
            achievements.append(.firstMins(mins: 30))
            
        case .overtimeFinished:
            
            // ^^^^^ SAME AS WHEN NORMAL OFFLINE TIEM FINISHED ^^^^^
            achievements.append(.firstMins(mins: 10))
            achievements.append(.firstMins(mins: 30))
            
            // ALSO EVENTS FOR OVERTIME...
            
        case .appOpened:
            break
        }
        
        
        return achievements
    }
    
    func updateProgress(for event: GameEvent) {
        
        switch event {
        case .offlineTimeFinished(let successful, let duration):
            
            // Update the total offline mins even if it was not successful
            totalOfflineMins += Int(duration.components.seconds / 60)
            
        case .overtimeFinished(let duration):
            
            totalOfflineMins += Int(duration.components.seconds / 60)
            
        case .appOpened:
            break
        }
        
    }
    
    func progress(for achievement: OfflineAchievement) -> Double? {
        switch achievement {
        case .firstMins(let mins):
            
            // e.g. totalOfflineMins = 5, mins = 10 (as in, your first 10 mins offline)
            // progress = 5 / 10 = half
            Double(totalOfflineMins) / Double(mins)
            
        default: nil
        }
    }
    
    func resetAllProgress() {
        totalOfflineMins = 0
    }

}
