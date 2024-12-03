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
    
    
    //MARK: - Notifications
    
    let center = UNUserNotificationCenter.current()
    let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString)!
    
    var notificationStatus: UNAuthorizationStatus? = nil
    
    func loadNotificationStatus() async {
        notificationStatus = await center.notificationSettings().authorizationStatus
    }
    
    func openNotificationSettings() {
        guard UIApplication.shared.canOpenURL(settingsURL) else { return }
        UIApplication.shared.open(settingsURL)
    }
    
    func requestNotificationPermission() {
        Task {
            do {
                let acceptedAlerts = try await center.requestAuthorization(
                    options: [.alert, .badge, .sound]
                )
                
                notificationStatus = acceptedAlerts ? .authorized : .denied
                
            } catch {
                print("Error requesting notifications \(error)")
            }
        }
    }

}
