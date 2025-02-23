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
    
    
    // Store the duration
    var duration: Duration? {
        switch self {
        case .offlineTimeFinished(_, let duration):
            duration
        case .overtimeFinished(let duration):
            duration
        default: nil
        }
    }
}
