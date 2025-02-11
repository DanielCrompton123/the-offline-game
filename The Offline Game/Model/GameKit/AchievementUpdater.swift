//
//  AchievementUpdater.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import Foundation

protocol AchievementUpdater {
    
    // Conforming types must implement a method to get the achievements for a particular event
    // It should filter the achievements it gives baded on the event conditions, for example, the offline duration.
    func achievements(for event: GameEvent) -> [OfflineAchievement]
    
    // Updates the progress towards a particular achievement
    func updateProgress(for event: GameEvent)
    
    // Gets the progress towards a particular achievement
    func progress(for achievement: OfflineAchievement) -> Double?
    
    // Reset progress for all achievements
    func resetAllProgress()
    
}
