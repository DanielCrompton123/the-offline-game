//
//  GameEvent.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import Foundation

enum GameEvent {
    
    // triggers the offline time achievements to be updated
    case offlineTimeFinished(successful: Bool, Duration)
    
    // triggers when the overtime time ends
    case overtimeFinished(Duration)
    
    // triggers leaderboard update
    case appOpened
    
    
    // Array of achievement updaters that manage updating achievements
    var updaters: [any AchievementUpdater] {
        switch self {
            
        case .offlineTimeFinished: [
            OfflineTimeAchievementUpdater.shared,
            OfflinePeriodsUpdater.shared
        ]
            
            
        case .appOpened: [
            LeaderboardUpdater.shared
        ]
            
        case .overtimeFinished: [
            OfflineTimeAchievementUpdater.shared
        ]
            
        }
    }
}
