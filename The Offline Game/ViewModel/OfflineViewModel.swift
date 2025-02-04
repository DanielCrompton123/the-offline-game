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
        
        Task {
            // Add one to the offline count
            do {
                try await offlineCountViewModel?.increase()
            } catch {
                self.error = error.localizedDescription
                print("🔢 Error increasing offline count: \(error.localizedDescription)")
            }
        }
        
        // Now add the live activity
        liveActivityViewModel?.startActivity(overtime: false)
        
        scheduleOfflineTimer()
        
        // Now schedule a notification to be posted to the user when their offline time ends
        let formattedDuration = state.formattedDuration(width: .abbreviated)
        
        OfflineNotification.congratulatoryNotification(
            endDate: state.endDate!, // unwrapped- just set startDate and endDate depends on it
            formattedDuration: formattedDuration
        ).post()
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
                self?.offlineTimeFinished(successfully: true)
            }
        }
    }
    
    
    
    func offlineTimeFinished(successfully: Bool) {
        print("offline time finished successfully=\(successfully)")
        
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        
        // DON'T set it to nil straight away because the user may want to stay offline, if they succeeded with this one and take their overtime
        // Instead do it in another func and call this if the user dismisses the congrats view without pressing "stay offline"
        
        // If the offline time ended in failure, the view won't give them the choice of staying offline so we should just set it to nil
        if !successfully {
            state.startDate = nil
        }
        
        Task {
            do {
                // Now subtract 1 from the offline count
                try await offlineCountViewModel?.decrease()
            } catch {
                self.error = error.localizedDescription
                print("🔢 Error decreasing offline count: \(error.localizedDescription)")
            }
        }
        
        // Manage presentation of sheets
        state.isOffline = false
        userShouldBeCongratulated = successfully
        userDidFail = !successfully
        
        // stop the live activity
        liveActivityViewModel?.stopActivity()
        
        // Now revoke any success notifications if we need to

        OfflineNotification.congratulatoryNotification(endDate: .now, formattedDuration: "").revoke()
        
        // Now handle achievements by delegating responsibility to the offline achievements view model
        if successfully {
            gameKitViewModel?.achievementsViewModel?.event(.offlineTimeFinishedSuccessfully(state.durationSeconds))
        }
        
        // If we HAVE BEEN overtime, make sure this ends by setting the overtime duration (distance between overtime start and now)
        // have been been overtime = (overtime start != nil)
        
        if let overtimeStartDate = state.overtimeStartDate {
            state.overtimeDuration = .seconds( overtimeStartDate.distance(to: Date()) )
            
            // Also reset the overtime start date?
        }
        
    }
    
    
    func confirmOfflineTimeFinished() {
        
        // Set the overtime duration
        guard let secs = state.overtimeStartDate?.distance(to: Date()) else { return }
        
        state.overtimeDuration = .seconds(secs)
        
        // Now reset the overtime start date AND the overtime duration
        state.overtimeStartDate = nil
        state.overtimeDuration = nil
        
        // decrease the count
//        offlineCountViewModel?.decrease()
        // Done in the offlineTimeFinished
        
        
        // reset the pause time
        totalPauseDuration = .seconds(0)
    }
    
    
    func beginOfflineOvertime() {
        // When the user wants OVERTIME this is called.
        // Set isOffline, and update the counter and the live activity
        
        state.isOffline = true
        
        Task {
            // Add one to the offline count
            do {
                try await offlineCountViewModel?.increase()
            } catch {
                self.error = error.localizedDescription
                print("🔢 Error increasing offline count: \(error.localizedDescription)")
            }
        }
        
        userShouldBeCongratulated = false
        liveActivityViewModel?.startActivity(overtime: true)
        
        // Also set the overtime start date
        state.overtimeStartDate = Date()
    }
    
    
    
    var pauseDate: Date?
    var totalPauseDuration = Duration.seconds(0)

    func pauseOfflineTime() {
        print("Pausing offline time")
        
        // - Cancel notifications and timers
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        
        // Now actually pause it
        OfflinePauseHelper.pause(state: &state)
    }
    
    
    
    func resumeOfflineTime() {
        
        OfflinePauseHelper.resume(state: &state)
        
        scheduleOfflineTimer()
        
    }
    
}

