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
    
    //MARK: - User defaults keys
    
    static let userDefaultsShouldShowOnboardingKey = "shouldShowOnboarding"
    static let userDefaultsUserAgeRawValueKey = "userAgeRawValue"
    static let userDefaultsShouldShowActivitiesViewKey = "shouldShowActivities"
    static let userDefaultsDurationSecondsKey = "durationSeconds"
    static let userDefaultsOfflineStateKey = "isOffline"
    static let userDefaultsStartDateKey = "startDate"
    static let userDefaultsUserIdKey = "userID"
    
    //MARK: - IDs
    
    static let offlineDurationEndedNotificationId = (Bundle.main.bundleIdentifier ?? "") + ".offlineTimeEndedNotificationIdentifier"
    static let offlineReminderNotificationId = (Bundle.main.bundleIdentifier ?? "") + ".offlineReminderNotificationIdentifier"
    static let appTerminatedNotificationId = "appTerminated"
    static let gracePeriodStartedNotificationId = "gracePeriodStarted"
    static let gracePeriodEndedNotSuccessfullyNotificationId = "gracePeriodEndedNotSuccessfully"
    static let firebaseOfflineCountKey = "offlineCount"
    
    //MARK: - Offline duration constants
    
    static let maximumOfflineSecs: TimeInterval = 24 * 60 * 60 // 24 hours
#if DEBUG
    static let minimumOfflineSecs: TimeInterval = 30
#else
    static let minimumOfflineSecs: TimeInterval = 10 * 60
#endif
    
    static let offlineDurationSecsRange: ClosedRange<TimeInterval> = minimumOfflineSecs...maximumOfflineSecs
    static let secsStep: TimeInterval = 5 * 60 // Slider increments in minutes
    
    static let offlineGracePeriod: TimeInterval = 20
    static let offlineGracePeriodDelaySinceProtectedDataAvailability: TimeInterval = 5
    
    //MARK: - Deep links
    
    static let appSettingsURL = URL(string: UIApplication.openSettingsURLString)! // force unwrapping a system property in a variable
    static let notificationSettingsURL = URL(string: UIApplication.openNotificationSettingsURLString)!
    
    //MARK: - Strings / UI
    
    static let activityIcons = ["figure.walk", "figure.run.treadmill", "figure.american.football", "figure.archery", "figure.basketball", "figure.climbing", "figure.curling", "figure.dance", "figure.skiing.downhill", "figure.hiking", "figure.outdoor.cycle", "figure.pool.swim", "figure.ice.skating"]
        
    static let activityIconChangeInterval: TimeInterval = 2.25
    
    static let systemArrowIcon = "chevron.forward.dotted.chevron.forward"


    //MARK: - APIs
    
    static let boredAPIEndpoint = "https://bored-api.appbrewery.com/random"
    
}
