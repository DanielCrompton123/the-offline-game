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
    
    
    @AppStorage("totalOvertime") private var totalOvertime: Double = 0.0
    
    
    
    // STORE values here
    
    // Store the highest offline period reached by the user
    @AppStorage("highestOfflineSecs") private var highestOfflineSecs: TimeInterval = 0
    
    // Store the total offline time done by the user
    @AppStorage("totalOfflineSecs") private var totalOfflineSecs: TimeInterval = 0
    
    
    
    func achievements(for event: GameEvent) -> [OfflineAchievement] {
        switch event {
            
        case .offlineTimeFinishedSuccessfully:
            [
//                .first10Min, .first30Min,
//                
//                .oneHrTot, .twoHrTot, .fiveHrTot, .tenHrTot, .fifteenHrTot, .twentyHrTot, .fiftyHrTot, .oneHundredHrTot,
//                
//                .oneHrBlk, .twoHrBlk, .fiveHrBlk, .tenHrBlk, .fifteenHrBlk, .twentyHrBlk, .twentyFourHrBlk, .thirtySixHrBlk,
//                
//                .thirtyMinOvt, .twoHrOvt, .fiveHrOvt,
//                
//                .twoDaysRunning, .sevenDaysRunning,
//                
//                .fiveOffPds, .tenOffPds, .fiftyOffPds
            ]
            
            
        case .appOpened:
            []
        }
    }
    
    
    func progress(for achievement: OfflineAchievement) -> Double? {
        nil
    }
    
    
    func updateProgress(for event: GameEvent) {
        
    }
    
    
    
    func resetProgress(for achievement: OfflineAchievement) {
        
    }
    
    
    func resetAllProgress() {
        
    }
}
