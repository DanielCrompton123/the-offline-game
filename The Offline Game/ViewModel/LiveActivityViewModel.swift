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
        
        // Create attributes
        let attributes = LiveActivityTimerAttributes(peopleOffline: offlineCountViewModel?.count ?? Int.random(in: 50...100))
        
        // Create initial state
        guard let state = getState() else {
            print("📣 Could not create activity state: no start date or overtime start date")
            return
        }
        
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
            print("📣 Error requesting live activity: \(error)")
        }
    }
    
    
    
    func stopActivity() {
        // Update activity state
        // Dummy data
        let state = LiveActivityTimerAttributes.ContentState(
            offlineTime: .normal(
                duration: .seconds(0),
                startDate: Date()
            )
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
        
        guard let state = getState() else {
            print("📣 Could not update activity with new activity state: no start date or overtime start date")
            return
        }

        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.update(content)
        }
    }
    
    
    private func getState() -> LiveActivityTimerAttributes.ContentState? {
        guard let offlineViewModel else { return nil }
        
        if offlineViewModel.state.isInOvertime,
           let overtimeStartDate = offlineViewModel.state.overtimeStartDate {
            
            return LiveActivityTimerAttributes.ContentState(
                offlineTime: .overtime(startDate: overtimeStartDate)
            )
            
        } else if let startDate = offlineViewModel.state.startDate {
            
            return LiveActivityTimerAttributes.ContentState(
                offlineTime: .normal(
                    duration: offlineViewModel.state.durationSeconds,
                    startDate: startDate
                )
            )
        } else {
            return nil
        }
        
    }
    
}
