//
//  AppBlockerViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 3/9/25.
//

import Foundation
import FamilyControls
import ManagedSettings


// We need permission to block apps and use other screenTime APIS
// FamilyControls API is purposed to AUTHORIZE this
// Individuals can authorize themselves to make changes (with managed settings) and allow background stuff to run (with device activity)
// OR children can get their parents to authenticate them
// (Then the children have limited privileges defined by the managed settings framework)
// The device activity extensions run at intervals to impose the restrictions (e.g. block TikTok after 1 hour)



@Observable
class AppBlockerViewModel {
    
    static private let authorizationCenter = AuthorizationCenter.shared
        
    func requestPermission() async throws {
        
        try await Self.authorizationCenter.requestAuthorization(for: .individual)
        
    }
    
    
    func setAppsStatus(blocked: Bool) {
        
    }
    
}
