//
//  OfflineState.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/3/25.
//

import Foundation

struct OfflineState {
    
    //MARK: - Offline duration
    
    // store the number of offline seconds selected by the user
    // If nothing is selected, store 20 minutes
    var durationSeconds: Duration = UserDefaults.standard.double(forKey: K.userDefaultsDurationSecondsKey) == 0 ?
        .seconds(20 * 60) :
        .seconds(UserDefaults.standard.double(forKey: K.userDefaultsDurationSecondsKey)) {
            
        didSet {
            // When set, persist it in user defaults
            UserDefaults.standard.set(durationSeconds.components.seconds, forKey: K.userDefaultsDurationSecondsKey)
        }
    }
    
    func formattedDuration(width: Duration.UnitsFormatStyle.UnitWidth = .wide) -> String {
        durationSeconds.offlineDisplayFormat(width: width)
    }
    
    
    //MARK: - Offline state
    
    enum State: Int {
        case none, offline, paused
    }
    
    var state = State.none {
        // When we set the state value, store in user defaults
        didSet { UserDefaults.standard.set(state.rawValue, forKey: K.userDefaultsOfflineStateKey) }
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
    
    
    //MARK: - Dates & durations
    
    // When did the user go offline?
    var startDate: Date? {
        willSet {
            // BEFORE updating the start date, set the old elapsed time.
            // because if setting the startDate to nil, in didSet the elapsed time would be nil too
            // Only update it if we are resetting the start date back to nil again
            if newValue == nil { oldElapsedTime = elapsedTime }
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
    var endDate: Date? {
        guard let startDate else { return nil }
        return startDate.addingTimeInterval(durationSeconds.seconds)
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
    
    // Used in pausing the offline time
    var pauseDate: Date?
    
    // Accumulate the pause time (i.e. if pausing multiple times)
    var totalPauseDuration = Duration.seconds(0)
    
}
