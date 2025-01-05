//
//  OfflineViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


@Observable
class OfflineViewModel {
    
    
    //MARK: - Initialization
    
    init(durationSeconds: TimeInterval, isOffline: Bool = false, startDate: Date? = nil, endOfflineTimer: Timer? = nil, isPickingDuration: Bool = false, userShouldBeCongratulated: Bool = false, liveActivityViewModel: LiveActivityViewModel? = nil) {
        self.durationSeconds = durationSeconds
        self.isOffline = isOffline
        self.startDate = startDate
        self.endOfflineTimer = endOfflineTimer
        self.isPickingDuration = isPickingDuration
        self.userShouldBeCongratulated = userShouldBeCongratulated
        self.liveActivityViewModel = liveActivityViewModel
    }
    
    
    init() {
        // Restore the things from user defaults
        
        // The `UserDefaults.standard.double` defaults to 0.0 if the value doesn't exist but we want it to default to 20 minutes.
        let durationSeconds = UserDefaults.standard.double(forKey: K.userDefaultsDurationSecondsKey)
        self.durationSeconds = durationSeconds == 0.0 ? 20*60 : durationSeconds
        
        isOffline = UserDefaults.standard.bool(forKey: K.userDefaultsIsOfflineKey) // default to false
        
        startDate = UserDefaults.standard.object(forKey: K.userDefaultsStartDateKey) as? Date // default to nil
        
        if isOffline {
            scheduleOfflineTimer()
        }
    }
    
    
    
    //MARK: - Offline duration
    
    // store the number of offline minutes selected by the user
    var durationSeconds: TimeInterval = 20 * 60 { // 20 minutes
        didSet {
            // When set, persist it in user defaults
            UserDefaults.standard.set(durationSeconds, forKey: K.userDefaultsDurationSecondsKey)
#warning("The durationSeconds is set extrenuousely each time the slider changes")
        }
    }
    var durationMinutes: TimeInterval {
        get { durationSeconds / 60 }
        set { durationSeconds = newValue * 60 }
    }
    
    
    
    //MARK: - Offline state
    
    // Is the user offline?
    // Used to trigger presentation of the offline view
    var isOffline = false {
        didSet {
            UserDefaults.standard.set(isOffline, forKey: K.userDefaultsIsOfflineKey)
        }
    }
    
    // When did the user go offline?
    var startDate: Date? {
        didSet {
            UserDefaults.standard.set(startDate, forKey: K.userDefaultsStartDateKey)
        }
    }
    
    // When can they do online?
    // Diaplayed in the UI with Text(Date, style: .timer)
    var endDate: Date? {
        guard let startDate else { return nil }
        return startDate.addingTimeInterval(durationSeconds)
    }
    
    // Used in the offline progress bar gauges
    var offlineProgress: CGFloat? {
        guard let elapsedTime else { return nil }
        return min(max(CGFloat(elapsedTime / durationSeconds), 0), 1)
    }
    
    // Elapsed time used in ther live activity and the offline progress calculation
    var elapsedTime: TimeInterval? {
        guard let startDate else { return nil }
        return Date().timeIntervalSince(startDate)
    }
    
    // Used to call the function to end the offline period (e.g. bringing up the congrats view and dismissing the OfflineView)
    var endOfflineTimer: Timer? // ONLY TRIGGERS at the `endDate`
    
    func goOffline() {
        isPickingDuration = false
        isOffline = true
        startDate = Date()
        
        // Add one to the offline count
        offlineCountViewModel?.increase()
        
        // Now add the live activity
        liveActivityViewModel?.startActivity()
        
        scheduleOfflineTimer()
        
        // Now schedule a notification to be posted to the user when their offline time ends
        NotificationsHelper.post(
            title: "You did it!",
            message: "Congrats for going offline for \(durationSeconds) seconds! Open the app to review your experience.",
            id: K.offlineDurationEndedNotificationId,
            at: endDate! // Unwrapped because we just set startDate and endDate depends on it
        )
    }
    
    
    private func scheduleOfflineTimer() {
        guard let endDate else {
            print("Don't call scheduleOfflineTimer is endDate is nil")
            return
            
        }
        // Schedule the `offlineTimeFinished` function to be called at the `endDate`
        endOfflineTimer = Timer.scheduledTimer(withTimeInterval: endDate.timeIntervalSinceNow,
                                               repeats: false) { [weak self] timer in
            // may execute on a background thread
            DispatchQueue.main.async {
                self?.offlineTimeFinished()
            }
        }
    }
    
    
    func offlineTimeFinished() {
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        startDate = nil
        
        // Now subtract 1 from the offline count
        offlineCountViewModel?.decrease()
        
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
    var offlineCountViewModel: OfflineCountViewModel?
}
