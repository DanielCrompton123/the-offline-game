//
//  OfflinePeriodsUpdater.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/22/25.
//

import Foundation
import SwiftUI


class OfflinePeriodsUpdater: AchievementUpdater {
    
    private init() { }
    
    static let shared = OfflinePeriodsUpdater()
    
    
    
    @AppStorage("numOffPds") private var numOfflinePeriods: Int = 0
    
    
    
    func achievements(for event: GameEvent) -> [OfflineAchievement] {
        switch event {
        case .offlineTimeFinishedSuccessfully(let duration):
            
            // Here, only give the relevant achievements if the offline duration is in the correct range:
            
            // Only add progress towards achievemnts if they spent at least to minutes offline.
            #if DEBUG
            return [.periods(num: 5), .periods(num: 10), .periods(num: 50)]
            #else
            if duration.components.seconds > 600 {
                return [.periods(num: 5), .periods(num: 10), .periods(num: 50)]
            } else {
                return []
            }
            #endif
            
            
        case .appOpened:
            return []
        }
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
        print("resetAllProgress for periods updater: numOfflinePeriods = \(numOfflinePeriods)")
    }
}
