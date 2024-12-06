//
//  OfflineViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


@Observable
class OfflineViewModel {
    
    
    
    //MARK: - Offline duration
    
    // store the number of offline minutes selected by the user
    var durationSeconds: TimeInterval = 20 * 60 // 20 minutes
    var durationMinutes: TimeInterval {
        get { durationSeconds / 60 }
        set { durationSeconds = newValue * 60 }
    }
    
    // Maximum and minimum duration
    static let maximumOfflineMinutes: TimeInterval = 24 * 60 // 24 hours
#if DEBUG
    static let minimumOfflineMinutes: TimeInterval = 0.25 // 15 seconds
#else
    static let minimumOfflineMinutes: TimeInterval = 10
#endif
    
    static let offlineDurationRange: ClosedRange<TimeInterval> = minimumOfflineMinutes...maximumOfflineMinutes
    static let minuteStep: TimeInterval = 1 // Slider increments in minutes
    
    func formatTimeRemaining() -> (timeString: String, unitString: String) {
        
        let minuteRangeInSeconds: ClosedRange<TimeInterval> = 0...59 // in seconds
        
        // If the time is a number of minutes (e.g. 0 to 59 minutes) -- use the `minuteRange` for this -- then display "XX MINUTES",
        // If it's a number of hours, display "XX.X hours"
        
        let isMinutes = minuteRangeInSeconds.contains(durationMinutes)
        
        return isMinutes ?
        (timeString: String(format: "%.0f", durationMinutes), unitString: "Minutes") : // Mins
        (timeString: String(format: "%.1f", durationMinutes / 60), unitString: "Hours") // Mins -> Hrs
    }
    
    
    
    
    //MARK: - Offline state
    
    // Is the user offline?
    // Used to trigger presentation iof the offline view
    var isOffline = false
    
    // When did the user go offline?
    var startDate: Date?
    var endDate: Date? {
        guard let startDate else { return nil }
        return startDate.addingTimeInterval(durationSeconds)
    }
    
    var timeRemaining: TimeInterval? = 0
    var timeRemainingString: String? {
        guard let timeRemaining else { return nil }
        return format(timeRemaining)
    }
    
    func loadTimeRemaining() {
        guard let endDate else { return }
//        print("Time remaining = \(Date()).distanceTo (\(startDate) + \(offlineSeconds))")
        timeRemaining = Date().distance(to: endDate)
    }
    
    
    func goOffline() {
//        print("Going offline for \(offlineSeconds) seconds")
        
        isOffline = true
        startDate = Date()
        timeRemaining = durationSeconds
        
        // Now create the UI updating timer that triggers every second and calls `loadTimeRemaining`.
        // If the offline time runs out, it should call `offlineTimeFinished`
        secondTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            // may execute on a background thread
            DispatchQueue.main.async {
                print("Tiemr fired -- Just loaded time remaining -- \(self?.timeRemaining ?? 0)")
                
                if (self?.timeRemaining ?? 0) < 0 {
                    self?.offlineTimeFinished()
                } else {
                    self?.loadTimeRemaining()
                }
            }
        })
        
        // Schedule the notification to be sent for when the offline time ends
        let offlineTimeEndedID = Bundle.main.bundleIdentifier! + ".offlineTimeEndedNotificationIdentifier"
        
        NotificationsHelper.post(
            title: "You did it!",
            message: "Congrats for going offline for \(durationSeconds) seconds! Open the app to review your experience!",
            id: offlineTimeEndedID,
            at: endDate! // Unwrapped because we just set startDate and endDate depends on it
        )
    }
    
    
    func offlineTimeFinished() {
        secondTimer?.invalidate()
        secondTimer = nil
        isOffline = false
        startDate = nil
        timeRemaining = nil
        userShouldBeCongratulated = true
        
        // Post a notification to congratulate the user
        // Post the notification here instantly instead of schedule posting (in goOffline) because it my need to be cancelled if the user goes online (then the notification would be delayed a period).
//        NotificationsHelper.post(
//            title: "You can use your phne again now!",
//            message: "You did it, congrats! Open the Offline app and share your experience!",
//            at: Date() // Post NOW!
//        )
    }
    
    
    
    
    //MARK: - UI Updating
    
    var secondTimer: Timer?
    var userShouldBeCongratulated = false

    func format(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad] // Ensures "03:09" instead of "3:9"
        return formatter.string(from: timeInterval) ?? "0:00"
    }
}
