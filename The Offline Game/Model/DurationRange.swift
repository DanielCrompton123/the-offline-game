//
//  DurationRange.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/10/25.
//

import Foundation


enum DurationRange: CaseIterable {
    case mins,
    hrToFiveHrs,
    fiveHrsToTwelveHrs,
    twelveHrsToThirtySixHrs
    
    var rangeInSecs: ClosedRange<Double> {
        let oneMin = 60.0
        let oneHr = 60.0 * 60.0
        
        return switch self {
        case .mins:
            // 5 mins ... 1 hour
            (5 * oneMin) ... oneHr
        case .hrToFiveHrs:
            oneHr ... (5 * oneHr)
        case .fiveHrsToTwelveHrs:
            (5 * oneHr) ... (12 * oneHr)
        case .twelveHrsToThirtySixHrs:
            (12 * oneHr) ... (36 * oneHr)
        }
    }
    
    func formatted() -> String {
        let lowerBoundFormatted = Duration.seconds(rangeInSecs.lowerBound).offlineDisplayFormat(width: .abbreviated)
        let upperBoundFormatted = Duration.seconds(rangeInSecs.upperBound).offlineDisplayFormat(width: .abbreviated)
        
        return "\(lowerBoundFormatted) - \(upperBoundFormatted)"
    }
    
    var step: Double {
        let oneMin = 60.0
        let oneHr = 60.0 * 60.0
        
        return switch self {
        case .mins: oneMin * 5
        case .hrToFiveHrs: oneMin * 10
        case .fiveHrsToTwelveHrs: oneMin * 30
        case .twelveHrsToThirtySixHrs: oneHr
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .mins:
            30
        case .hrToFiveHrs:
            35
        case .fiveHrsToTwelveHrs:
            40
        case .twelveHrsToThirtySixHrs:
            50
        }
    }
}
