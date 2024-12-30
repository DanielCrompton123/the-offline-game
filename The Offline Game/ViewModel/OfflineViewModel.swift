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
    
    
    
    //MARK: - Offline state
    
    // Is the user offline?
    // Used to trigger presentation iof the offline view
    var isOffline = false
    
    // When did the user go offline?
    var startDate: Date?
    // When can they do online?
    // Diaplayed in the UI with Text(Date, style: .timer)
    var endDate: Date? {
        guard let startDate else { return nil }
        return startDate.addingTimeInterval(durationSeconds)
    }
    
    // Used to call the function to end the offline period (e.g. bringing up the congrats view and dismissing the OfflineView)
    var endOfflineTimer: Timer? // ONLY TRIGGERS at the `endDate`
    
    func goOffline() {
        isOffline = true
        startDate = Date()
        
        // Now add the live activity
        liveActivityViewModel?.startActivity()
        
        // Schedule the `offlineTimeFinished` function to be called at the `endDate`
        endOfflineTimer = Timer.scheduledTimer(withTimeInterval: endDate!.timeIntervalSinceNow,
                                               repeats: false) { [weak self] timer in
            // may execute on a background thread
            DispatchQueue.main.async {
                self?.offlineTimeFinished()
            }
        }
        
        // Now schedule a notification to be posted to the user when their offline time ends
        NotificationsHelper.post(
            title: "You did it!",
            message: "Congrats for going offline for \(durationSeconds) seconds! Open the app to review your experience.",
            id: K.offlineDurationEndedNotificationId,
            at: endDate! // Unwrapped because we just set startDate and endDate depends on it
        )
    }
    
    
    func offlineTimeFinished() {
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        startDate = nil
        
        // Manage presentation of sheets
        isOffline = false
        userShouldBeCongratulated = true
        
        // stop the live activity
        liveActivityViewModel?.stopActivity()
    }
    
    
    
    var isPickingDuration = false // Makes the OfflinetimeView appear to pick duration
    var userShouldBeCongratulated = false // Makes the congratulatory view appear in the main view
    
    
    
    //MARK: - Other
    
    var liveActivityViewModel: LiveActivityViewModel?
//
//    func format(_ timeInterval: TimeInterval) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.minute, .second]
//        formatter.unitsStyle = .positional
//        formatter.zeroFormattingBehavior = [.pad] // Ensures "03:09" instead of "3:9"
//        return formatter.string(from: timeInterval) ?? "0:00"
//    }
}
