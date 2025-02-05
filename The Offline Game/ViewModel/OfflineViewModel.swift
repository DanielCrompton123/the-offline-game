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
    
    
    private func count(increasing: Bool) {
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
    
    
    var overtimeStartTimer: Timer?
    var overtimeStartTimerBGTaskId: UIBackgroundTaskIdentifier?
    
    
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
        
        // Manage presentation of sheets
        state.isOffline = false
        
        userShouldBeCongratulated = successfully
        userDidFail = !successfully
        
        // stop the live activity
        liveActivityViewModel?.stopActivity()
        
        // Now revoke any success notifications if we need to
        OfflineNotification.congratulatoryNotification(endDate: .now, formattedDuration: "").revoke()
        
        if state.isInOvertime {
            OfflineOvertimeHelper.endOvertime(state: &state)
        }
        
        // Now handle achievements by delegating responsibility to the offline achievements view model
//        if successfully {
            //gameKitViewModel?.achievementsViewModel?.event(.offlineTimeFinishedSuccessfully(durationSeconds))
//        }
                
        // When the offline time ends successfully, wait 10 seconds and then automatically go overtime, accounting for the 10 seconds.
        // DO THIS IN THE HELPER
        
//        if successfully {
//            
//            // Schedule a timer to time 10 seconds (and use a background task is the device is in the background)
//            if UIApplication.shared.applicationState == .background {
//                overtimeStartTimerBGTaskId = UIApplication.shared.beginBackgroundTask()
//                
//                // Ended BG task when app goes into foreground
//                print("Begun background task \(overtimeStartTimerBGTaskId!.rawValue) to allow overtimeStartTimer to run")
//            }
//            
//            // Now schedule a task for 10 seconds
//            overtimeStartTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
//                
//                print("overtimeStartTimer triggered, start date!=nil?\(self?.state.startDate != nil)")
//                
//                // After 10 seconds, and we have not CONFIRMED going online, then automatically start overtime
////                if self?.startDate != nil {
//                if self?.userShouldBeCongratulated == true {
//                    self?.beginOfflineOvertime(offset: -10) // 10 seconds in the past
//                    print("Begun overtime (10 secs ago)")
//                }
//                // BUT account for the 10 seconds delay
//                
//                // Also END BG task
//                if let overtimeStartTimerBGTaskId = self?.overtimeStartTimerBGTaskId {
//                    UIApplication.shared.endBackgroundTask(overtimeStartTimerBGTaskId)
//                    print("Ended overtimeStartTimerBGTask")
//                }
//                
//            }
//            
//        }
        
    }
    
    
    func resetOfflineTime() {
        
        #warning("Called as soon as congrats view appears")
        
        print("🔁 Resetting offline state")
        
        // Reset the state
        state.reset()
        
        // Cancel the timer
        self.overtimeStartTimer?.invalidate()
        self.overtimeStartTimer = nil
//        #warning("the overtime period keeps starting after 10 seconds repeatedly")
    
        // Make sure sheets are presented
        userDidFail = false
        userShouldBeCongratulated = false
        
        // End the overtimeStartTimerBGTaskId
        if let overtimeStartTimerBGTaskId {
            UIApplication.shared.endBackgroundTask(overtimeStartTimerBGTaskId)
        }
    }
    
    
    
    func beginOfflineOvertime(offset: TimeInterval) {
        print("Beginning overtime")
        // Offset positive for in the future, and negative for in the past

        // Set isOffline, and update the counter and the live activity
                
        count(increasing: true)
        
        OfflineOvertimeHelper.startOvertime(state: &state, offset: offset)
        
        userShouldBeCongratulated = false
        liveActivityViewModel?.startActivity(overtime: true)
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
        scheduleOfflineTimer()
    }
    
}

