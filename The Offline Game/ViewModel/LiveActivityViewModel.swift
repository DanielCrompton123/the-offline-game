//
//  LiveActivityViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/7/24.
//

import ActivityKit
import SwiftUI

@Observable
class LiveActivityViewModel {
    
    private var activity: Activity<LiveActivityTimerAttributes>?
    
    weak var offlineViewModel: OfflineViewModel?
    weak var offlineCountViewModel: OfflineCountViewModel?
    

    func startActivity(overtime: Bool) {
        guard let offlineViewModel, let startDate = offlineViewModel.state.startDate else { return }
        
        // Create attributes
        let attributes = LiveActivityTimerAttributes()
        
        // Create initial state
        let state = LiveActivityTimerAttributes.ContentState(
            duration: offlineViewModel.state.durationSeconds,
            startDate: startDate,
            peopleOffline: offlineCountViewModel?.count ?? 0
        )
        
        let content = ActivityContent(state: state, staleDate: nil)
        
        // Request to start activity
        do {
            activity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil // NEED to pass nil here. Defaut is to allow push notifications to update the live activity
            )
        } catch {
            print("Error requesting live activity: \(error)")
        }
    }
    
    
    
    func stopActivity() {
        // Update activity state
        // Dummy data
        let state = LiveActivityTimerAttributes.ContentState(
            duration: nil,
            startDate: .now,
            peopleOffline: 0
        )
        
        // Request activity to end
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            for activity in Activity<LiveActivityTimerAttributes>.activities {
                await activity.end(content, dismissalPolicy: .immediate)
            }
        }
    }
    
    
    
    func updateActivity() {
        guard let offlineViewModel, let startDate = offlineViewModel.state.startDate else { return }
        
        let state = LiveActivityTimerAttributes.ContentState(
            duration: offlineViewModel.state.durationSeconds,
            startDate: startDate,
            peopleOffline: offlineCountViewModel?.count ?? 0
        )

        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.update(content)
        }
    }
    
}
