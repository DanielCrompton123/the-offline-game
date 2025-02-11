//
//  Duration extension.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import Foundation



extension Duration {
    
    var seconds: Double {
        // int seconds from components + attoseconds (converted to seconds)
        // 10 pow 18 attoseconds in a second
        Double(components.seconds) + ( Double(components.attoseconds) / 10e18 )
    }
    
    
    func offlineDisplayFormat(width: UnitsFormatStyle.UnitWidth = .wide) -> String {
        // E.g. "13 secs", "20 mins", "1 hr, 30 mins"
        
        let units: Set<UnitsFormatStyle.Unit>/* = components.seconds < 60 ? [.seconds] : [.hours, .minutes]*/
        
        // If the duration is in seconds make sure the allowed units is seconds
        if components.seconds < 60 {
            units = [.seconds]
        }
        
        // If the duration is in minutes make sure allowed duration is in minutes
        else if components.seconds < (60 * 60) { // cutoff is 1hr (60secs * 60)
            units = [.minutes]
        }
        
        // If we have a number of hours return the hours THEN minutes
        else {
            units = [.hours, .minutes]
        }
        
        // format it
        return formatted(.units(allowed: units, width: width))
    }
    
    
    func offlineDisplayFormatComponents(width: UnitsFormatStyle.UnitWidth = .wide) -> [(String, String)] {
        // Firstly format it
        let formattedString = offlineDisplayFormat(width: width)
        
        // Now split into the hrs/mins components
        let components = formattedString.components(separatedBy: ", ")
        
        var output: [(String, String)] = []
        
        // Now take each and split it into duration string and unit
        for c in components {
            let seperatedC = c.components(separatedBy: .whitespaces)
            
            guard seperatedC.count == 2 else {
                print("Splitting \(c) did not have 2 elements (duration string and unit)")
                continue
            }
            output.append((seperatedC[0], seperatedC[1]))
        }
        
        return output
    }
    
    
    
    static func fromStrings(hour: String, minute: String, second: String) -> Duration? {
        
        guard let hour = Double(hour),
              let minute = Double(minute),
              let second = Double(second) else {
            return nil
        }

        let totalSeconds = (hour * 3600) + (minute * 60) + second
        
        return .seconds(totalSeconds)
    }
    
    
    func strings() -> (hour: String, minute: String, second: String) {
        
        let totalSeconds = components.seconds
        
        let hours = totalSeconds / 3600
        let hrsText = String(hours)
        
        let minutes = (totalSeconds % 3600) / 60
        let minsText = String(minutes)
        
        let seconds = totalSeconds % 60
        let secsText = String(seconds)
        
        return (hour: hrsText, minute: minsText, second: secsText)
    }
    
    
}
