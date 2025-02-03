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
        
//    init() {
//        // Restore the things from user defaults
//        
//        // The `UserDefaults.standard.double` defaults to 0.0 if the value doesn't exist but we want it to default to 20 minutes.
//        let durationSeconds = UserDefaults.standard.double(forKey: K.userDefaultsDurationSecondsKey)
//        self.durationSeconds = durationSeconds == 0.0 ? .seconds(20*60) : .seconds(durationSeconds)
//        
//        let stateRawValue = UserDefaults.standard.integer(forKey: K.userDefaultsOfflineStateKey)
//        state = State(rawValue: stateRawValue) ?? .none
//        
//        startDate = UserDefaults.standard.object(forKey: K.userDefaultsStartDateKey) as? Date // default to nil
//        
//        if isOffline {
//            scheduleOfflineTimer()
//        }
//    }
    
    
    
//    //MARK: - Offline duration
//    
//    // store the number of offline minutes selected by the user
//    var durationSeconds: Duration = .seconds(20 * 60) { // 20 minutes
//        didSet {
//            // When set, persist it in user defaults
//            UserDefaults.standard.set(durationSeconds.components.seconds, forKey: K.userDefaultsDurationSecondsKey)
//        }
//    }
//    
    
    
//    //MARK: - Offline state
//    
//    enum State: Int {
//        case none, offline, paused
//    }
//    
//    var state = State.none {
//        // When we set the state value, store in user defaults
//        didSet { UserDefaults.standard.set(state.rawValue, forKey: K.userDefaultsOfflineStateKey) }
//    }
//    
//    // Is the user offline?
//    // Used to trigger presentation of the offline view
//    var isOffline: Bool {
//        get { state != .none } // We are offline if the state is either paused or actually offline
//        set { state = newValue ? .offline : .none }
//    }
//    var isPaused: Bool { state == .paused }
//    
//    // When did the user go offline?
//    var startDate: Date? {
//        willSet {
//            // BEFORE updating the start date, set the old elapsed time.
//            // because if setting the startDate to nil, in didSet the elapsed time would be nil too
//            // Only update it if we are resetting the start date back to nil again
//            if newValue == nil { oldElapsedTime = elapsedTime }
//        }
//        didSet {
//            UserDefaults.standard.set(startDate, forKey: K.userDefaultsStartDateKey)
//            
//            // Now update oldDtartDate & oldElapsedTime
//            if oldValue != nil {
//                oldStartDate = oldValue
//            }
//        }
//    }
//    
//    // Used to access the previous start date even when it's reset
//    var oldStartDate: Date?
//    
//    // When can they do online?
//    // Diaplayed in the UI with Text(Date, style: .timer)
//    var endDate: Date? {
//        guard let startDate else { return nil }
//        return startDate.addingTimeInterval(durationSeconds.seconds)
//    }
//    
//    // Used in the offline progress bar gauges
//    var offlineProgress: CGFloat? {
//        // The start date's distance to the current date
//        guard let endDate else { return nil }
//        return startDate?.completionTo(endDate)
//    }
//    
//    // Elapsed time used in the live activity and the offline progress calculation
//    var elapsedTime: TimeInterval? {
//        guard let startDate else { return nil }
//        return Date().timeIntervalSince(startDate)
//    }
//    // Old elapsed time used in success congrats view when the elaopsedTime has been reset
//    var oldElapsedTime: TimeInterval?
//    
    // Used to call the function to end the offline period (e.g. bringing up the congrats view and dismissing the OfflineView)
    var endOfflineTimer: Timer? // ONLY TRIGGERS at the `endDate`

    var state = OfflineState()
    
    func goOffline() {
        print("Going offline...")
        isPickingDuration = false
        state.isOffline = true
        state.startDate = Date()
        
        // Add one to the offline count
        offlineCountViewModel?.increase()
        
        // Now add the live activity
        liveActivityViewModel?.startActivity()
        
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
        state.startDate = nil
        
        // Now subtract 1 from the offline count
        offlineCountViewModel?.decrease()
        
        // Manage presentation of sheets
        state.isOffline = false
        userShouldBeCongratulated = successfully
        userDidFail = !successfully
        
        // stop the live activity
        liveActivityViewModel?.stopActivity()
        
        // Now revoke any success notifications if we need to
        OfflineNotification.congratulatoryNotification(endDate: .now, formattedDuration: "").revoke()
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
        
        OfflinePauseHelper.resume(state: &state)
        
        // reschedule the end timer
        scheduleOfflineTimer()
        
    }
    
    
    //MARK: - Other
    
    var isPickingDuration = false // Makes the OfflinetimeView appear to pick duration
    var userShouldBeCongratulated = false // Makes the congratulatory view appear in the main view
    var userDidFail = false // Presents the failure view
    
    var liveActivityViewModel: LiveActivityViewModel?
    var offlineCountViewModel: OfflineCountViewModel?
}
