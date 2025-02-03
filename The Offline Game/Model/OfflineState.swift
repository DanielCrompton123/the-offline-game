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
    var durationSeconds: Duration = .seconds(20 * 60) { // 20 minutes
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
        guard let startDate else { return nil }
        return Date().timeIntervalSince(startDate)
    }
    // Old elapsed time used in success congrats view when the elaopsedTime has been reset
    var oldElapsedTime: TimeInterval?
    
    // Used in pausing the offline time
    var pauseDate: Date?
    
}
