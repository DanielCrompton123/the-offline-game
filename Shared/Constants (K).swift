//
//  Constants.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/30/24.
//

import Foundation
import SwiftUI

struct K {
    private init() { }
    
    //MARK: - Keys
    
    static let userDefaultsShouldShowOnboardingKey = "shouldShowOnboarding"
    static let userDefaultsUserAgeRawValueKey = "userAgeRawValue"
    static let userDefaultsShouldShowActivitiesViewKey = "shouldShowActivities"
    static let offlineDurationEndedNotificationId = (Bundle.main.bundleIdentifier ?? "") + ".offlineTimeEndedNotificationIdentifier"
    
    //MARK: - Offline duration constants
    
    static let maximumOfflineMinutes: TimeInterval = 24 * 60 // 24 hours
#if DEBUG
    static let minimumOfflineMinutes: TimeInterval = 0.25 // 15 seconds
#else
    static let minimumOfflineMinutes: TimeInterval = 10
#endif
    
    static let offlineDurationRange: ClosedRange<TimeInterval> = minimumOfflineMinutes...maximumOfflineMinutes
    static let minuteStep: TimeInterval = 5 // Slider increments in minutes
    
    //MARK: - Deep links
    
    static let appSettingsURL = URL(string: UIApplication.openSettingsURLString)! // force unwrapping a system property in a variable
    static let notificationSettingsURL = URL(string: UIApplication.openNotificationSettingsURLString)!
    
}
