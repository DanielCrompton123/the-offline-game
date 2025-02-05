//
//  OfflineOvertimeHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/4/25.
//

import Foundation


struct OfflineOvertimeHelper {
    
    private init() { }
    
    
    
    static func startOvertime(state: inout OfflineState, offset: TimeInterval) {
        state.state = .offline
        state.overtimeStartDate = Date().addingTimeInterval(offset)
        state.isInOvertime = true
    }
    
    
    static func pauseOvertime() {
        
    }
    
    
    static func resumeOvertime() {
        
    }
    
    
    static func endOvertime(state: inout OfflineState) {
        state.isInOvertime = false
    }
}


