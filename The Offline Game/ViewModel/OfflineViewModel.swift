//
//  OfflineViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


@Observable
class OfflineViewModel {
    
    // Used to call the function to end the offline period (e.g. bringing up the congrats view and dismissing the OfflineView)
    var endOfflineTimer: Timer? // ONLY TRIGGERS at the `endDate`

    var state = OfflineState()
    
    var error: String?
    
    
    // In the initializer make sure that the offline start date & duration are recovered IF THE UDSER IS HARD COMMITTING..
    // In a hard commit they can close the app (terminate) without ending offline time.
    // When the app opens again, their offline state should be remembered
    
    init() {
        do {
            if let state = try OfflineStatePersistance.restore() {
                self.state = state
            }
        } catch {
            print("💽 Failed to restore persisted offline state")
        }
    }
    
    
    //MARK: - Other
    
    var isPickingDuration = false // Makes the OfflinetimeView appear to pick duration
    var userShouldBeCongratulated = false // Makes the congratulatory view appear in the main view
    
    var userDidFail = false // Presents the failure view
    
    var liveActivityViewModel: LiveActivityViewModel?
    var offlineCountViewModel: OfflineCountViewModel?
    var gameKitViewModel: GameKitViewModel?
    var appBlockerViewModel: AppBlockerViewModel?
    
    
    
    func goOffline() {
        print("Going offline")
        isPickingDuration = false
        state.isOffline = true
        state.startDate = Date()
        
        count(increasing: true)
        
        // Now add the live activity
        if let liveActivityViewModel {
            print("📣 Starting live activity")
            liveActivityViewModel.startActivity()
        } else {
            print("📣 Live activity view model in offline view model was nil!")
        }
        
        scheduleOfflineTimer()
        
        // Now schedule a notification to be posted to the user when their offline time ends
        let formattedDuration = state.durationSeconds.offlineDisplayFormat(width: .abbreviated)
        
        OfflineNotification.congratulatoryNotification(
            endDate: state.endDate!, // unwrapped- just set startDate and endDate depends on it
            formattedDuration: formattedDuration
        ).post()
        
        // NOW BLOCK APPS if we are in a hard commit session
        if state.isHardCommit {
            if let appBlockerViewModel {
                print("🔑 Blocking apps")
                appBlockerViewModel.setAppsStatus(blocked: true)
            } else {
                print("🔑 Could not lock apps as appBlockerViewModel in offlineViewModel is nil")
            }
        }
    }
    
    
    func count(increasing: Bool) {
        Task {
            // Add one to the offline count
            do {
                if increasing {
                    try await offlineCountViewModel?.increase()
                } else {
                    try await offlineCountViewModel?.decrease()
                }
            } catch {
                self.error = error.localizedDescription
                print("🔢 Error \(increasing ? "increasing" : "increasing") offline count: \(error.localizedDescription)")
            }
        }
    }
    
        
    private func scheduleOfflineTimer() {
        guard let endDate = state.endDate else {
            print("Don't call scheduleOfflineTimer is endDate is nil")
            return
        }
        
        // Schedule the `offlineTimeFinished` function to be called at the `endDate`
        endOfflineTimer = Timer.scheduledTimer(
            withTimeInterval: endDate.timeIntervalSinceNow,
            repeats: false
        ) { [weak self] _ in
            // may execute on a background thread
            DispatchQueue.main.async {
                print("Offline end timer triggered!")
                self?.endOfflineTime(successfully: true)
            }
        }
        
        print("Scheduled offline end timer")
    }
    
    
    // Ends the NORMAL AND OVERTIME offline periods
    func endOfflineTime(successfully: Bool) {
    
        print("Ending normal offline time, successfully=\(successfully)")
        
        // Cancel the offline end timer
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        
        // Only reset the start date to nil when we are resetting offline state.
        // When the user failed (violating grace period) the offline time will be ended, and the state will be cleared.
//        state.startDate = nil
        
        count(increasing: false)
        
        if let liveActivityViewModel {
            print("📣 Ending live activity")
            liveActivityViewModel.stopActivity()
        } else {
            print("📣 Live activity view model in offline view model was nil!")
        }
        
        // Now revoke any success notifications if we need to
        OfflineNotification.congratulatoryNotification(endDate: .now, formattedDuration: "").revoke()
        
        var shouldStartAutomatically = true
        
        // Handle achievements by delegating responsibility to the achievements view model.
        // Also make sure score is added to leaderboard too
        
        let event: GameEvent = state.isInOvertime ?
            .overtimeFinished(state.overtimeElapsedTime!) :
            .offlineTimeFinished(successful: successfully, state.elapsedTime!)
        // MAKE SURE IT'S NOT THE DURATION -- if they didn't complete the offline time then the duration would not work
        // FORCE UNWRAP PROPERTIES because they WILL have values if the isInOvertime is correct.
        
        if let achievementsViewModel = gameKitViewModel?.achievementsViewModel {
            Task {
                await OfflineAchievementsProgressManager.shared.handle(
                    event: event,
                    achievementViewModel: achievementsViewModel
                )
            }
        }
        
        // Now handle the event in the leaderboard view model.
        // This means adding their offline time to the leaderboard
        if let leaderboardViewModel = gameKitViewModel?.leaderboardViewModel {
            Task {
                await leaderboardViewModel.updateOfflineTimeLeaderboardScore(event: event)
            }
        }
        
        // If we were in overtime, end this
        if state.isInOvertime {
            OfflineOvertimeHelper.shared.endOvertime(viewModel: self)
            
            // We should also NOT automatically start the overtime
            shouldStartAutomatically = false
        }
        
        // If we were NOT in overtime, and we finished successfully, start the overtime automatically (after 10 seconds)
        else if successfully && shouldStartAutomatically {
            
            state.isOffline = false
            OfflineOvertimeHelper.shared.startAutomatically(viewModel: self)
        }
        
        // Manage presentation of sheets
        userShouldBeCongratulated = successfully
        userDidFail = !successfully
        // ^^^ DO this AFTER setting isOffline (either to false, or in endOvertime) to avoid "only presenting a single sheet is supported" error.
        // Make sure it's dismissed before presenting these sheets
        
        // Now we should make sure apps are UNBLOCKED
        print("🔑 Unblocking apps")
        appBlockerViewModel?.setAppsStatus(blocked: false)

    }
    
    
    func resetOfflineTime() {
        print("🔁 Resetting offline state")
        
        // Reset the state
        state.reset()
        
        // Cancel the timer

        // Make sure sheets are presented
        userDidFail = false
        userShouldBeCongratulated = false
        
        // Cancel the automatic offline time
        OfflineOvertimeHelper.shared.cancelAutomaticOvertime()
    }
    
    

    func pauseOfflineTime() {
        print("Pausing offline time")
        
        // - Cancel notifications and timers
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        
        // Now actually pause it
        OfflinePauseHelper.pause(state: &state)
    }
    
    
    
    func resumeOfflineTime() {
        print("Resuming offline time")
        
        OfflinePauseHelper.resume(state: &state)
        
        // We don't want to schedule this timer is we have paused overtime -- for overtime there's no end timer.
        if !state.isInOvertime {
            scheduleOfflineTimer()
        }
    }
    
}
