//
//  GameKitViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI
import GameKit

@Observable
class GameKitViewModel {
    
    var error: String?
    var gameCenterEnabled = false
    
    // Get the root view controller
    var rootViewController: UIViewController {
        UIApplication.shared.windows.first?.rootViewController ?? UIHostingController(rootView: EmptyView())
    }

    
    func authenticatePlayer() {
        // https://developer.apple.com/documentation/gamekit/authenticating-a-player
        // To sign in the user we assign a handler
        
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            // Here, error and view controller are optionals.
            // If the user needs to do something else we present the VC. Once they did it, this calls again.
            // Otherwise check if an error exists.
            // Otherwise, if both are nil AND player.isAuthenticated, we signed in successfully
            // If viewController, error = nil AND isAuthenticated are false, the user opted out so we should disable game center.
            
            print("GKLocalPlayer.local.authenticateHandler called")
            
            // First, present the view controller if we need to
            if let viewController {
                // Present it
                print("Presenting VC. rootViewController = \(self?.rootViewController)")
                self?.rootViewController.present(viewController, animated: true)
                return
            }
            
            // Now if the user doesn't have to do anything else check if there was an error
            if let error {
                print("Error with GameKit: \(error)")
                self?.error = error.localizedDescription
            }
            
            // Now we should check if they want game kit enabled or not.
            print("GKLocalPlayer.local.isAuthenticated = \(GKLocalPlayer.local.isAuthenticated)")
            self?.gameCenterEnabled = GKLocalPlayer.local.isAuthenticated
            
            // Now enable or disable some things
        }
    }
    
}
