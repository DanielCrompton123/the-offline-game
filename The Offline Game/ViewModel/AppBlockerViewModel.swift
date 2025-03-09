//
//  AppBlockerViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 3/9/25.
//

import Foundation
import FamilyControls
import ManagedSettings
import Combine


// We need permission to block apps and use other screenTime APIS
// FamilyControls API is purposed to AUTHORIZE this
// Individuals can authorize themselves to make changes (with managed settings) and allow background stuff to run (with device activity)
// OR children can get their parents to authenticate them
// (Then the children have limited privileges defined by the managed settings framework)
// The device activity extensions run at intervals to impose the restrictions (e.g. block TikTok after 1 hour)



@Observable
class AppBlockerViewModel {
    
    static let authorizationCenter = AuthorizationCenter.shared
    
    var status: AuthorizationStatus?
    var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        // When the status changes update the status
        Self.authorizationCenter.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStatus in
                print("🧑‍🧑‍🧒‍🧒 AuthorizationCenter status update: \(newStatus)")
                self?.status = newStatus
            }
            .store(in: &cancellables)
    }
        
    func requestPermission() async throws {
        
        try await Self.authorizationCenter.requestAuthorization(for: .individual)
        
        // Now set the status
        status = Self.authorizationCenter.authorizationStatus
        
        print("🧑‍🧑‍🧒‍🧒 Requested permissions for FamilyControls, status = \(status!)")
    }
    
    
    func revokePermission() async throws {
        
        _ = try await withCheckedThrowingContinuation { continuation in
            
             Self.authorizationCenter.revokeAuthorization { result in
                
                 switch result {
                 case .success:
                     continuation.resume(returning: ())
                 case .failure(let failure):
                     continuation.resume(throwing: failure)
                 }
                
            }
        }
    }
    
    
    func setAppsStatus(blocked: Bool) {
        
    }
    
}
