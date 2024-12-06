//
//  OnboardingViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/3/24.
//

import UserNotifications
import UIKit


@Observable
class OnboardingViewModel {
    
    
    //MARK: - Onboarding presentation
    
    private let hasSeenOnboardingUserDefaultsKey = "hasSeenOnboarding"
    
    var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: hasSeenOnboardingUserDefaultsKey)
        }
    }
    
    var hasNotSeenOnboarding: Bool {
        get { !hasSeenOnboarding }
        set { hasSeenOnboarding = !newValue }
    }
    
    
    //MARK: - Initializer
    
    init() {
        hasSeenOnboarding = UserDefaults.standard.bool(
            forKey: hasSeenOnboardingUserDefaultsKey
        ) // Defaults to false
    }

}
