//
//  OfflineGracePeriodHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/6/25.
//

import SwiftUI


class OfflineTracker {
    
    private init() { }
    static let shared = OfflineTracker()
    
    
    var offlineViewModel: OfflineViewModel?
    
    private var backgroundTimer: Timer?
    private var backgroundTimerTaskId: UIBackgroundTaskIdentifier?
    
    var appDelegate: AppDelegate?
    
    
    func startGracePeriod(forOvertime: Bool) {
        
        GracePeriodHelper.shared.startGracePeriod { [weak self] in
            
            // On start
            // When it started, pause offline time:
            
            // - this cancels the success notification among others
            self?.offlineViewModel?.pauseOfflineTime()
            
        } onEnd: { [weak self] successfully in
            print("Grace period ended successfully=\(successfully)")
            
            // If it ended successfully, continue the offline time
            if successfully {
                self?.offlineViewModel?.resumeOfflineTime()
            }
            
            // if it was NOT succcessful, just end the offline time
            else {
                self?.offlineViewModel?.endOfflineTime(successfully: false)
            }
            
        }
        
    }
    
    
    func endGracePeriod(successfully: Bool) {
        GracePeriodHelper.shared.endGracePeriod(successfully: successfully)
    }
    
    
    func scenePhaseChanged(to newValue: ScenePhase) {
        
        guard let offlineViewModel else {
            print("OfflineTracker -- offlineViewModel is nil")
            return
        }
        
        // Only do this if we are offline AND NOT HARD COMMIT
        // In hard commit apps are blocked, so we don't need to use the grace period stuff
        guard offlineViewModel.state.isOffline else { return }
        
        guard !offlineViewModel.state.isHardCommit else {
            print("Hard commit, so no grace period needed")
            return
        }
        
        
        if newValue == .background {
            print("App went into background")
            // If the app went into background because the phone turned off do nothing
            // If the phone was turned on though (the user switched to another app maybe) offer them grace period
            
            // We need to use a background task here so that the timer can run in the background
            backgroundTimerTaskId = UIApplication.shared.beginBackgroundTask()
            
            backgroundTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
                print("1.5 seconds since background. Protected data will become unavailable = \(self?.appDelegate?.protectedDataWillBecomeUnavailable ?? false)")
                
                // End BG task
                if let backgroundTimerTaskId = self?.backgroundTimerTaskId {
                    UIApplication.shared.endBackgroundTask(backgroundTimerTaskId)
                }

                // If protected data WILL become unavailable, that's great, stay offline.
                // Otherwise, the app will have been put into background because the user closed it.
                // So we should start a grace period
                if self?.appDelegate?.protectedDataWillBecomeUnavailable == false {
                    // If we are currently OVERTIME, then we don't want to start a grace period. Just wait 10 seconds for the user to go offline again, then if they still haven't gone back onto the app in 10 seconds, then end their overtime.
                    
                    // If we ARE OFFLINE NORMALLY then start a grace period
                    
                    if let offlineViewModel = self?.offlineViewModel {
                        self?.startGracePeriod(forOvertime: offlineViewModel.state.isInOvertime)
                    }
                    
                }
            }
                        
        } else {
            print("App foreground/inactive")
            backgroundTimer?.invalidate()
            backgroundTimer = nil
            
            // Still make sure any background tasks are terminated (if they weren't in a second)
            if let backgroundTimerTaskId {
                UIApplication.shared.endBackgroundTask(backgroundTimerTaskId)
            }
            
            // When the app goes active or inactive, (foreground) end the grace period successfully, but only if a grace period was started.
            OfflineTracker.shared.endGracePeriod(successfully: true)
        }
    }
    
    
    func appTerminated() {
        
        guard let offlineViewModel, offlineViewModel.state.isOffline else {
            print("OfflineTracker offlineViewModel is nil OR not offline so app termination not handled")
            return
        }
        
        // When it terminates, PERSIST THE CURRENT OFFLINE STATE BUT only if we are hard committing (where it should be recovered).
        // This is allowed because while the app is terminated other apps are still blocked.
        if offlineViewModel.state.isHardCommit {
            do {
                try OfflineStatePersistance.persist(offlineViewModel.state)
            } catch {
                print("Could not persist offline state to disk: \(error)")
            }
        }
        
        // When the app terminates (NOT HARD COMMITTING), tell the user that their offline time has ended
        else {
            offlineViewModel.endOfflineTime(successfully: false)
            
            #warning("`OfflineNotification.appTerminated.post()` -- notification never posted")
            OfflineNotification.appTerminated.post()
        }
    }
    
    
    func protectedDataDidBecomeAvailable() {
        // Only do this if we are offline AND SOFT COMMITTING
        guard offlineViewModel?.state.isOffline == true &&
        offlineViewModel?.state.isHardCommit == false else { return }
        
        // When the phone turns on, we need to ensure our app is in the foreground, but give the user 5 seconds to open the app before starting their grace period
        // Do we need to convert it to Timer? NO because we check this state is correct with if statement
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            
            print("Waited 5s for the user to open the app and protectedDataWillBecomeUnavailable = \(self?.appDelegate?.protectedDataWillBecomeUnavailable ?? false) and applicationState = \(UIApplication.shared.applicationState)")
            
            if UIApplication.shared.applicationState != .active,
               self?.appDelegate?.protectedDataWillBecomeUnavailable == false {
                OfflineTracker.shared.startGracePeriod(forOvertime: false)
            }
        }
        
        // ^^^^^
        // Start when the protected data becomes available and end when it becomes unavailable
        // Make sure the protected data will become available property is still false in the async After, before starting the grace period. IN THOSE 5 SECONDS THE APP HAS CLOSED AGAIN AND THE CONDITION `UIApplication.shared.applicationState != .active` IS FALSE SO THE GRACE PERIOD STARTS

    }
    
}
