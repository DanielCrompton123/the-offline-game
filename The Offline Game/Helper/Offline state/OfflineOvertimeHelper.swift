//
//  OfflineOvertimeHelper.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/4/25.
//

import UIKit


class OfflineOvertimeHelper {
    
    private init() { }
    static let shared = OfflineOvertimeHelper()
    
    
    var overtimeStartTimer: Timer?
    var overtimeStartTimerBGTaskId: UIBackgroundTaskIdentifier?
    
    
    func startOvertime(viewModel: OfflineViewModel, offset: TimeInterval = 0.0) {
        // Called by the automatic timer, or the "go overtime" button in congrats view
        
        print("Beginning overtime")
        
        
        viewModel.count(increasing: true)
        
        // Set isOffline, and update the counter and the live activity
        // Offset positive for in the future, and negative for in the past
        viewModel.state.state = .offline
        viewModel.state.overtimeStartDate = Date().addingTimeInterval(offset)
        
        // Cancel the automatic one
        cancelAutomaticOvertime()
        
        viewModel.userShouldBeCongratulated = false
        viewModel.liveActivityViewModel?.startActivity()
        
    }
    

    func endOvertime(viewModel: OfflineViewModel) {
        viewModel.state.isOffline = false
    }
    
    
    func startAutomatically(viewModel: OfflineViewModel) {
        // When the offline time ends successfully, wait 10 seconds and then automatically go overtime, accounting for the 10 seconds.
        
        let foregroundDelay: TimeInterval = 5.0
        let delay: TimeInterval = UIApplication.shared.applicationState == .active ? foregroundDelay : 0.0
        
        // Automatically start the overtime
        // if the app is currently open in the foreground, and the success sheet is visible, after 5 seconds we should start the overtime automatically.
        // If the app is in the background (device turned off) then we start it right now.
        // However if the app is in the background BUT the phone is turned ON then don't start the activity. Use the app delegate for this?
        
        #warning("If the app is in the background BUT the phone is turned ON then don't start the activity automatically.")
        
        // Schedule a timer to time 10 seconds (and use a background task is the device is in the background)
        if UIApplication.shared.applicationState == .background {
            overtimeStartTimerBGTaskId = UIApplication.shared.beginBackgroundTask()

            // Ended BG task when app goes into foreground
            print("Begun background task \(overtimeStartTimerBGTaskId!.rawValue) to allow overtimeStartTimer to run")
        }
        
        // Now schedule a task for 10 seconds
        overtimeStartTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            
            // If 10 seconds has passed and the user has not reset the offline state (by dismissing the congrats view) then do nothing.
            // Then we should start their overtime for them, ACCOUNTING THE 10 SECONDS waiting.
            
            // However if they have the phone turned ON but they're not in this app, we shouldn't start automatically.
            if UIApplication.shared.isProtectedDataAvailable &&
            UIApplication.shared.applicationState == .background {
                print("🔓 Could not automatically start overtime as phone is on and app is in background")
                return
            }
            
            // Start date == nil if offline state was reset
            if viewModel.state.startDate != nil {
                self?.startOvertime(viewModel: viewModel, offset: -delay)
                print("Begun overtime (10 secs ago)")
            }
            
            // Also END BG task (even if the offline time was cancelled)
            if let overtimeStartTimerBGTaskId = self?.overtimeStartTimerBGTaskId {
                UIApplication.shared.endBackgroundTask(overtimeStartTimerBGTaskId)
                print("Ended overtimeStartTimerBGTask")
            }

        }
    }
    
    
    
    func cancelAutomaticOvertime() {
        // After 10 seconds of the congrats view showing & device on, the overtime automatically starts
        
        // Call when:
        // - Overtime started manually
        // - Offline state reset
        
        overtimeStartTimer?.invalidate()
        overtimeStartTimer = nil
        if let overtimeStartTimerBGTaskId {
            UIApplication.shared.endBackgroundTask(overtimeStartTimerBGTaskId)
        }
    }
}


