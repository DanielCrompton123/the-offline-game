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
        
    init() {
        // Restore the things from user defaults
        
        // The `UserDefaults.standard.double` defaults to 0.0 if the value doesn't exist but we want it to default to 20 minutes.
        let durationSeconds = UserDefaults.standard.double(forKey: K.userDefaultsDurationSecondsKey)
        self.durationSeconds = durationSeconds == 0.0 ? .seconds(20*60) : .seconds(durationSeconds)
        
//        let stateRawValue = UserDefaults.standard.integer(forKey: K.userDefaultsOfflineStateKey)
//        state = State(rawValue: stateRawValue) ?? .none
//        
//        startDate = UserDefaults.standard.object(forKey: K.userDefaultsStartDateKey) as? Date // default to nil
//        
//        if isOffline {
//            scheduleOfflineTimer()
//        }
    }
    
    
    
    //MARK: - Offline duration
    
    // store the number of offline minutes selected by the user
    var durationSeconds: Duration = .seconds(20 * 60) { // 20 minutes
        didSet {
            // When set, persist it in user defaults
            UserDefaults.standard.set(durationSeconds.components.seconds, forKey: K.userDefaultsDurationSecondsKey)
        }
    }
    
    
    
    //MARK: - Offline state
    
    enum State: Int {
        case none, offline, paused
    }
    
    var state = State.none {
        // When we set the state value, store in user defaults
        didSet {
            UserDefaults.standard.set(state.rawValue, forKey: K.userDefaultsOfflineStateKey)
        }
    }

    // Is the user offline?
    // Used to trigger presentation of the offline view
    var isOffline: Bool {
        get { state != .none } // We are offline if the state is either paused or actually offline
        set { state = newValue ? .offline : .none }
    }
    
    var isPaused: Bool { state == .paused }
    
    // Check if the user is in overtime offline
    var isInOvertime: Bool {
        // Is end date BEFORE now?
        guard let endDate else { return false }
        return isOffline && ( Date().distance(to: endDate) < 0 )
    }
    
    // When did the user go offline?
    var startDate: Date? {
        willSet {
            // BEFORE updating the start date, set the old elapsed time.
            // because if setting the startDate to nil, in didSet the elapsed time would be nil too
            // Only update it if we are resetting the start date back to nil again
//            if newValue == nil { oldElapsedTime = elapsedTime }
        }
        didSet {
            UserDefaults.standard.set(startDate, forKey: K.userDefaultsStartDateKey)
            
            // Now update oldDtartDate & oldElapsedTime
            if oldValue != nil {
                oldStartDate = oldValue
            }
        }
    }
    
    // Used to access the previous start date even when it's reset
    var oldStartDate: Date?
    
    // When can they do online?
    // Diaplayed in the UI with Text(Date, style: .timer)
    // Also add on any paused time
    var endDate: Date? {
        guard let startDate else { return nil }
        return startDate.addingTimeInterval(durationSeconds.seconds).addingTimeInterval(totalPauseDuration.seconds)
    }
    
    // Used in the offline progress bar gauges
    var offlineProgress: CGFloat? {
        // The start date's distance to the current date
        guard let endDate else { return nil }
        return startDate?.completionTo(endDate)
    }
    
    // Elapsed time used in the live activity and the offline progress calculation
    var elapsedTime: TimeInterval? {
        // It is the time between going offline and (either now, or when the user paused offline time due to going on the home screen)
        // It is the lower value of either that or now.
        // Because we may be accessing the elapsed time after going overtime.
        // This WOULD be a sum of offline time + delay on congrats view + overtime.
        // Also make sure pause time is deducted
        
        guard let startDate else { return nil }
        
//        #error("Time interval incorrectly calculated")
        return min(
            Date().timeIntervalSince(startDate) - totalPauseDuration.seconds,
            durationSeconds.seconds
        )
    }
    // Old elapsed time used in success congrats view when the elapsedTime has been reset
//    var oldElapsedTime: TimeInterval?
    
    // The start date for overtime
    // This is NOT the same as the end date because the user may spend some time on the congrats screen or in the game center access point.
    var overtimeStartDate: Date?
    
    // This is the duration that the user was overtime for
    // Set when the overtime ends
    var overtimeDuration: Duration?
    
    // Used to call the function to end the offline period (e.g. bringing up the congrats view and dismissing the OfflineView)
    var endOfflineTimer: Timer? // ONLY TRIGGERS at the `endDate`
    
    // The notification posted when offline time completes
    var congratulatoryNotification: OfflineNotification?
    
    
    
    func goOffline() {
        print("Going offline")
        isPickingDuration = false
        isOffline = true
        startDate = Date()
        
        // Add one to the offline count
        offlineCountViewModel?.increase()
        
        // Now add the live activity
        liveActivityViewModel?.startActivity(overtime: false)
        
        scheduleOfflineTimer()
        
        // Now schedule a notification to be posted to the user when their offline time ends
        let formattedDuration = durationSeconds.offlineDisplayFormat(width: .abbreviated)
        
        congratulatoryNotification = OfflineNotification.congratulatoryNotification(
            endDate: endDate!, // unwrapped- just set startDate and endDate depends on it
            formattedDuration: formattedDuration
        )
        
        congratulatoryNotification?.post()
    }
    
    
    
    private func scheduleOfflineTimer() {
        guard let endDate else {
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
            startDate = nil
        }
        
        // Now subtract 1 from the offline count
        offlineCountViewModel?.decrease()
        
        // Manage presentation of sheets
        isOffline = false
        userShouldBeCongratulated = successfully
        userDidFail = !successfully
        
        // stop the live activity
        liveActivityViewModel?.stopActivity()
        
        // Now revoke any success notifications if we need to
        congratulatoryNotification?.revoke()
        
        // Now handle achievements by delegating responsibility to the offline achievements view model
        if successfully {
            gameKitViewModel?.achievementsViewModel?.event(.offlineTimeFinishedSuccessfully(durationSeconds))
        }
        
        // If we HAVE BEEN overtime, make sure this ends by setting the overtime duration (distance between overtime start and now)
        // have been been overtime = (overtime start != nil)
        
        if let overtimeStartDate {
            overtimeDuration = .seconds( overtimeStartDate.distance(to: Date()) )
            
            // Also reset the overtime start date
        }
        
    }
    
    
    func confirmOfflineTimeFinished() {
        
        // Set the overtime duration
        guard let secs = overtimeStartDate?.distance(to: Date()) else { return }
        
        overtimeDuration = .seconds(secs)
        
        // Now reset the overtime start date AND the overtime duration
        overtimeStartDate = nil
        overtimeDuration = nil
        
        // decrease the count
//        offlineCountViewModel?.decrease()
        // Done in the offlineTimeFinished
        
        
        // reset the pause time
        totalPauseDuration = .seconds(0)
    }
    
    
    func beginOfflineOvertime() {
        // When the user wants OVERTIME this is called.
        // Set isOffline, and update the counter and the live activity
        
        isOffline = true
        offlineCountViewModel?.increase()
        userShouldBeCongratulated = false
        liveActivityViewModel?.startActivity(overtime: true)
        
        // Also set the overtime start date
        overtimeStartDate = Date()
    }
    
    
    
    var pauseDate: Date?
    var totalPauseDuration = Duration.seconds(0)
    
    func pauseOfflineTime() {
        print("Pausing offline time")
        // - Record the time we pause at and set state
        pauseDate = Date()
        state = .paused
        
        // - Cancel notifications and timers
        endOfflineTimer?.invalidate()
        endOfflineTimer = nil
        congratulatoryNotification?.revoke()
        congratulatoryNotification = nil
    }
    
    
    
    func resumeOfflineTime() {
        // We can only resume if we have been paused
        guard isPaused, let pauseDate else {
            print("Only resume offline time when paused")
            return
        }
        
        print("Resuming offline time...")
        
        // - Calculate the duration we were paused for
        let pauseDuration = Date().timeIntervalSince(pauseDate)
        
        // - Reset pauseDate
        self.pauseDate = nil
        
        // - modify the end date. To do this we need to change the offline duration
//        durationSeconds += .seconds(pauseDuration)
//        #warning("This saves new value to user defaults")
        
        // - also add onto the total pause time
        // this will be affecting the elapsed time
        totalPauseDuration += .seconds(pauseDuration)
        
        // We can also do this by subtracting the pause duration from the start date.
        // This method will also ensure the elapsedTime value is correct
//        startDate = startDate?.addingTimeInterval(pauseDuration)
        
        // - reschedule the notification and end timer
        scheduleOfflineTimer()
        
        // abbreviated because we're in a notification
        let formattedDuration = durationSeconds.offlineDisplayFormat(width: .abbreviated)
        congratulatoryNotification = OfflineNotification.congratulatoryNotification(
            endDate: endDate!, // unwrapped- just set startDate and endDate depends on it
            formattedDuration: formattedDuration
        )
        congratulatoryNotification?.post()
    }
    
    
    //MARK: - Other
    
    var isPickingDuration = false // Makes the OfflinetimeView appear to pick duration
    var userShouldBeCongratulated = false // Makes the congratulatory view appear in the main view
    var userDidFail = false // Presents the failure view
    
    var liveActivityViewModel: LiveActivityViewModel?
    var offlineCountViewModel: OfflineCountViewModel?
    var gameKitViewModel: GameKitViewModel?
}
