//
//  LeaderboardUpdater.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/22/25.
//

import Foundation
import SwiftUI


// CLASS OR STRUCT
// Needs to be accessed by reference so class

class LeaderboardUpdater: AchievementUpdater {
    
    private init() { }
    
    static let shared = LeaderboardUpdater()
    
    
    func achievements(for event: GameEvent) -> [OfflineAchievement] {
        []
    }
    
    
    func updateProgress(for event: GameEvent) {
        
    }
    
    
    func progress(for achievement: OfflineAchievement) -> Double? {
        nil
    }
    
    
    func resetProgress(for achievement: OfflineAchievement) {
        
    }
    
    
    func resetAllProgress() {
        
    }
}
