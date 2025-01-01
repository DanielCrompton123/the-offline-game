//
//  DurationDisplayHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/30/24.
//

import Foundation


struct DurationDisplayHelper {
    private init() { }
    
    
    static func formatDuration(_ durationSecs: TimeInterval) -> String {
        let f = formatDurationWithUnits(durationSecs)
        return "\(f.timeString) \(f.unitString)"
    }
    
    
    static func formatDurationWithUnits(_ durationSecs: TimeInterval) -> (timeString: String, unitString: String) {
        let hours = durationSecs / 3600
        if hours >= 1 {
            return (timeString: String(format: "%.1f", hours),
                    unitString: hours == 1 ? "hour" : "hours")
        } else {
            let minutes = durationSecs / 60
            return (timeString: String(format: "%.0f", minutes),
                    unitString: minutes == 1 ? "minute" : "minutes")
        }
    }
}
