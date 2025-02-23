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
        
        var duration: Duration?
        var startDate: Date
        
        var endDate: Date? {
            guard let duration else { return nil }
            return startDate.addingTimeInterval(duration.seconds)
        }
        
        // Other properties that can be accessed
        var peopleOffline: Int
        
        static let preview = ContentState(duration: .seconds(60), startDate: Date(), peopleOffline: 590)
    }
    
}
