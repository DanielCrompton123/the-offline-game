//
//  GameEvent.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import Foundation

enum GameEvent {
    
    // triggers the offline time ahievements to be updated
    case offlineTimeFinishedSuccessfully(Duration)
    
    // triggers leaderboard update
    case appOpened
    
    
    // Array of achievement updaters that manage updating achievements
    var updaters: [any AchievementUpdater] {
        switch self {
            
        case .offlineTimeFinishedSuccessfully:
            [
                OfflineTimeAchievementUpdater.shared,
                OfflinePeriodsUpdater.shared
            ]
            
            
        case .appOpened:
            [LeaderboardUpdater.shared]
            
        }
    }
}
