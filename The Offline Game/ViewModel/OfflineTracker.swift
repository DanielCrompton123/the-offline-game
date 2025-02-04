//
//  OfflineGracePeriodHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/6/25.
//

import UIKit


class OfflineTracker {
    
    private init() { }
    
    static let shared = OfflineTracker()
    
    var offlineViewModel: OfflineViewModel?
    
    private let gracePeriodHelper = GracePeriodHelper.shared
    
    
    func startGracePeriod() {
        
        gracePeriodHelper.startGracePeriod { [weak self] in
            
            // On start
            // When it started, pause offline time:
            
            // - this cancels the success notification among others
            self?.offlineViewModel?.pauseOfflineTime()
            
        } onEnd: { [weak self] successfully in
            
            // If it ended successfully, continue the offline time
            if successfully {
                self?.offlineViewModel?.resumeOfflineTime()
            }
            
            // if it was NOT succcessful, just end the offline time
            else {
                self?.offlineViewModel?.offlineTimeFinished(successfully: false)
            }
            
        }
        
    }
    
    
    func endGracePeriod(successfully: Bool) {
        gracePeriodHelper.endGracePeriod(successfully: successfully)
    }
    
}
