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
    
    
    
    //MARK: - Other
    
    var isPickingDuration = false // Makes the OfflinetimeView appear to pick duration
    var userShouldBeCongratulated = false // Makes the congratulatory view appear in the main view
    
    var userDidFail = false // Presents the failure view
    
    var liveActivityViewModel: LiveActivityViewModel?
    var offlineCountViewModel: OfflineCountViewModel?
    var gameKitViewModel: GameKitViewModel?
    
    
    
    
    func goOffline() {
        print("Going offline")
        isPickingDuration = false
        state.isOffline = true
        state.startDate = Date()
        
        count(increasing: true)
        
        // Now add the live activity
        liveActivityViewModel?.startActivity(overtime: false)
        
        scheduleOfflineTimer()
        
        // Now schedule a notification to be posted to the user when their offline time ends
        let formattedDuration = state.durationSeconds.offlineDisplayFormat(width: .abbreviated)
        
        OfflineNotification.congratulatoryNotification(
            endDate: state.endDate!, // unwrapped- just set startDate and endDate depends on it
            formattedDuration: formattedDuration
        ).post()
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
        
        liveActivityViewModel?.stopActivity()
        
        // Now revoke any success notifications if we need to
        OfflineNotification.congratulatoryNotification(endDate: .now, formattedDuration: "").revoke()
        
        var shouldStartAutomatically = true
        
        // Before ending the overtime, report the event
        // Now handle achievements by delegating responsibility to the offline achievements view model
        if let achievementsViewModel = gameKitViewModel?.achievementsViewModel {
            
            let event: GameEvent = state.isInOvertime ?
                .overtimeFinished(state.overtimeElapsedTime ?? .seconds(0)) :
                .offlineTimeFinished(successful: successfully, state.durationSeconds)

            OfflineAchievementsProgressManager.shared.handle(
                event: event,
                achievementViewModel: achievementsViewModel
            )
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
