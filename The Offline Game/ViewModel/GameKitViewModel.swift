//
//  GameKitViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI
import GameKit

@Observable
class GameKitViewModel: NSObject {
    
    var error: String?
    var gameCenterEnabled = false
    var offlineViewModel: OfflineViewModel?
    
    private var presentingGKViewController: GKGameCenterViewController?
    private var oldRootVCPresentationController: UIViewController?
    
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
    
    
    func openAccessPoint() {
        GKAccessPoint.shared.location = .topTrailing
        GKAccessPoint.shared.isActive = true
    }
    
    
    func hideAccessPoint() {
        GKAccessPoint.shared.isActive = false
    }
    
    
    func openGKViewController(at state: GKGameCenterViewControllerState) {
        // Firstly to avoid the warning X is already presenting Y, dismiss the presenting controller.
        // Save it so it can be restored later
        oldRootVCPresentationController = rootViewController.presentedViewController
        rootViewController.presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            
            // When it dismisses, then make this one appear
            self?.presentingGKViewController = GKGameCenterViewController(state: state)
            self?.presentingGKViewController?.gameCenterDelegate = self
            
            if let presentingGKViewController = self?.presentingGKViewController {
                self?.rootViewController.present(presentingGKViewController, animated: true)
            }
        })
    }
}



//MARK: - GKGameCenterControllerDelegate conformance

extension GameKitViewModel: GKGameCenterControllerDelegate {
    
    // DISMISS IT PROPERLY HERE (not called "once it was dismissed"
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        // Firstly, dismiss it
        gameCenterViewController.dismiss(animated: true) { [weak self] in
            // When it finishes, present the old presented controller if we need to
            
            if let oldRootVCPresentationController = self?.oldRootVCPresentationController {
                self?.rootViewController.present(oldRootVCPresentationController, animated: true)
            }
        }
        // When the game center view controller disappears, make the access point re-appear...?
//        openAccessPoint()
    }
}
