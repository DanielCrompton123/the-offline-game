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
    

    func startActivity() {
        
        guard let offlineViewModel else {
            print("LiveActivityViewModel.offlineViewModel is nil")
            return
        }
        
        guard let startDate = offlineViewModel.state.startDate else {
            print("starting live activity... offline start date is nil")
            return
        }
        
        // Create attributes
        let attributes = LiveActivityTimerAttributes(peopleOffline: offlineCountViewModel?.count ?? 0)
        
        // Create initial state
        let state = LiveActivityTimerAttributes.ContentState(
            duration: offlineViewModel.state.durationSeconds,
            startDate: startDate
        )
        
        let content = ActivityContent(state: state, staleDate: nil)
        
        // Request to start activity
        do {
            activity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil // NEED to pass nil here. Defaut is to allow push notifications to update the live activity
            )
            
            print("📣 Requested activity \(activity!.id)")
        } catch {
            print("Error requesting live activity: \(error)")
        }
    }
    
    
    
    func stopActivity() {
        // Update activity state
        // Dummy data
        let state = LiveActivityTimerAttributes.ContentState(
            duration: nil,
            startDate: .now
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
            startDate: startDate
        )

        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.update(content)
        }
    }
    
}
