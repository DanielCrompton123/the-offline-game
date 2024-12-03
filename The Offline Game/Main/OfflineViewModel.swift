//
//  OfflineViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


enum NavigationStep {
    case home, offline
}


@Observable
class OfflineViewModel {
    
    // store the number of offline minutes selected by the user
    var offlineMinutes: TimeInterval = 20
    var offlineTime: TimeInterval {
        get {
            offlineMinutes / 60
        } set {
            offlineMinutes = newValue * 60
        }
    }
    
    // Is the user offline?
    var isOffline: Bool {
        get {
            currentOfflineStartDate == nil
        }
    }
    
    // When did the user go offline?
    var currentOfflineStartDate: Date?
    
    
    var navigation = NavigationPath() // Used to navigate 
    
    
    func goOffline() {
        // Go offline button pressed from the `OfflineTimeView`
        
        // At this point the navigation path has nothing in it so add something
        navigation.append(NavigationStep.offline)
        
        // Now set relevant properties and make sure date offline is set
        currentOfflineStartDate = .now
    }
}
