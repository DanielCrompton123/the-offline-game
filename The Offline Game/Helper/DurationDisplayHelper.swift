//
//  DurationDisplayHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/30/24.
//

import Foundation


struct DurationDisplayHelper {
    private init() { }
    
    
    static func formatDurationWithUnits(_ durationSecs: TimeInterval) -> (timeString: String, unitString: String) {
        
        let durationMinutes = durationSecs / 60
        
        let minuteRangeInSeconds: ClosedRange<TimeInterval> = 0...59 // in seconds
        
        // If the time is a number of minutes (e.g. 0 to 59 minutes) -- use the `minuteRange` for this -- then display "XX MINUTES",
        // If it's a number of hours, display "XX.X hours"
        
        let isMinutes = minuteRangeInSeconds.contains(durationMinutes)
        
        return isMinutes ?
        (timeString: String(format: "%.0f", durationMinutes), unitString: "Minutes") : // Mins
        (timeString: String(format: "%.1f", durationMinutes / 60), unitString: "Hours") // Mins -> Hrs
    }
}
