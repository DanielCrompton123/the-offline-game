//
//  LiveActivityTimerAttributes.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/6/24.
//

import ActivityKit
import SwiftUI


struct LiveActivityTimerAttributes: ActivityAttributes {
    
    // ContentState represents all the data that the widget relies on and can be refreshed from within the main app
    // A bit like an @State
    
    struct ContentState: Codable, Hashable {
        // If they were a lets the widget cannot be updated
        
        enum OfflineTime: Codable, Hashable {
            case normal(duration: Duration?, startDate: Date)
            case overtime(startDate: Date)
            
            var endDate: Date? {
                if case let .normal(duration, startDate) = self,
                   let duration {
                    return startDate.addingTimeInterval(duration.seconds)
                } else {
                    return nil
                }
            }
        }
        
        var offlineTime: OfflineTime
        
        var isOvertime: Bool {
            switch offlineTime {
            case .overtime: true
            case .normal: false
            }
        }
        
    }
    
    
    // WARNING: Will NOT work without at least 1 property here
    let peopleOffline: Int
    
}



//MARK: - Previews

extension LiveActivityTimerAttributes {
    static let preview = LiveActivityTimerAttributes(peopleOffline: 10)
}

extension LiveActivityTimerAttributes.ContentState {
    static let previewNormal = Self(offlineTime: .normal(duration: .seconds(30), startDate: Date()))
    static let previewOvertime = Self(offlineTime: .overtime(startDate: Date()))
}
