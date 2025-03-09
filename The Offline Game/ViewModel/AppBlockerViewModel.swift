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
    
    // A data store that applies settings to the current user or device.
    var settingsStore = ManagedSettingsStore()
    
    
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
        // BLOCK APPS hides their app icon and stops them opening.
        // NOT WORKING IN SIMULATOR
        
//        settingsStore.application.blockedApplications = blocked ? [.init(bundleIdentifier: "com.google.ios.youtube"), .init(bundleIdentifier: "com.apple.calculator"), .init(bundleIdentifier: "com.apple.Health"), .init(bundleIdentifier: "com.apple.MobileAddressBook")] : []
//        
//        print("🔑 Blocked apps: \(settingsStore.application.blockedApplications)")
        
        
        // SHIELDING APPS opens a sheet over the app instead of the app, and does not let the app open.
        
        settingsStore.shield.applicationCategories = blocked ? .all(except: []) : nil
        settingsStore.shield.webDomainCategories = blocked ? .all(except: []) : nil
        
        print("🔑 Shielded apps: \(String(describing: settingsStore.shield.applicationCategories))")
    }
    
}
