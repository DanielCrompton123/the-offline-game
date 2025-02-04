//
//  Date extension.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/5/25.
//

import CoreGraphics
import Foundation

// calling eg: startDate.completionTo(endDate)

extension Date {
    func completionTo(_ date2: Date) -> CGFloat {
        // Calculate the total distance between the start and end date
        let totalDistance = distance(to: date2)
        
        // Calculate the time elapsed between the current date and start date
        let currentDate = Date()
        let timeElapsed = distance(to: currentDate)
        
        // Divide the time elapsed by the total distance to get the completion
        let completion = abs(CGFloat(timeElapsed / totalDistance))
        return min(max(CGFloat(completion), 0), 1)
    }
}
