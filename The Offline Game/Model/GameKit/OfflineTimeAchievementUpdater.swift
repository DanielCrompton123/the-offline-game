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
        case .offlineTimeFinished(let successful, let duration):
            
            // Your first 10 / 30 minutes IF they went offline for this
            
            let first10MinsThreshold = 60 * 10
            let first30MinsThreshold = 60 * 30
            
            if duration.components.seconds >= first10MinsThreshold { // 600 secs = 10 mins
                achievements.append(.firstMins(mins: 10))
            }
            
            if duration.components.seconds >= first30MinsThreshold { // (600.0 * 3.0) = 30 min
                achievements.append(.firstMins(mins: 30))
            }
            
        case .overtimeFinished(let duration):
            
            // ^^^^^ SAME AS WHEN NORMAL OFFLINE TIEM FINISHED ^^^^^
            // Your first 10 / 30 minutes IF they went offline for this
            if Double(duration.seconds) > 600.0 { // 600 secs = 10 mins
                achievements.append(.firstMins(mins: 10))
            }
            
            if Double(duration.seconds) > (600.0 * 3.0) { // (600.0 * 3.0) = 30 min
                achievements.append(.firstMins(mins: 30))
            }
            
            // ALSO EVENTS FOR OVERTIME...
            
        case .appOpened:
            break
        }
        
        
        return achievements
    }
    
    func updateProgress(for event: GameEvent) {
        
        switch event {
        case .offlineTimeFinished(let successful, let duration):
            
            // Update the total offline mins IF it was successful
            if successful {
                totalOfflineMins += Int(duration.components.seconds / 60)
            }
            
        case .overtimeFinished(let duration):
            
            // Update the offline
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
