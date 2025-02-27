//
//  GameKitLeaderboardViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/16/25.
//

import Foundation
import GameKit

@Observable
class GameKitLeaderboardViewModel {
    weak var gameKitViewModel: GameKitViewModel?
    
    static private let offlineTimeLeaderboardID = "offlineTime"
    private var offlineTimeLeaderboard: GKLeaderboard?
    
    private var offlineTimeLeaderboardScore = 0
    
    var error: String?
    
    
    func loadLeaderboards() async {
        do {
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [Self.offlineTimeLeaderboardID])
            
            offlineTimeLeaderboard = leaderboards.first {
                $0.baseLeaderboardID == Self.offlineTimeLeaderboardID
            }
            print("🎮 Loaded \(leaderboards.count) leaderboards")
            
            await loadScores()
            print("🎮 Loaded scores for leaderboards")
            
        } catch {
            self.error = error.localizedDescription
            print("🎮 Error loading leaderboards: \(error)")
        }
    }

    // Helper function to load the scores for all the loaded leaderboards
    private func loadScores() async {
        do {
            if let offlineTimeLeaderboard {
                
                let entry = try await offlineTimeLeaderboard.loadEntries(
                    for: [GKLocalPlayer.local],
                    timeScope: .week
                )
                // Entry: (GKLeaderboard.Entry?, [GKLeaderboard.Entry])
                // 0 = Entry for local player
                // 1 = Entries for other players
                
                self.offlineTimeLeaderboardScore = entry.0?.score ?? 0
                #warning("Loading score failed")
            } else {
                print("🎮 Loading score for offlineTimeLeaderboard but it's nil")
            }
            
        } catch {
            print("🎮 Failed to load score for \(Self.offlineTimeLeaderboardID): \(error)")
            self.error = error.localizedDescription
        }
    }
    
    
    // Update the offline-time leaderboard score
    func updateOfflineTimeLeaderboardScore(event: GameEvent) async {
        do {
            
            // Get the duration we went offline (which is either the offline OR overtime time)
            guard let duration = event.duration else {
                print("🎮 Event has no duration, so no score can be added to GK")
                return
            }
            
            // Make sure we have a leaderboard
            guard let offlineTimeLeaderboard else {
                print("🎮 Trying to submit score to offlineTimeLeaderboard but the leaderboard was not loaded")
                return
            }
            
            // Add the score to the LOCAL score property AND submit to GK
            
            offlineTimeLeaderboardScore += Int(duration.components.seconds)
            // FORCE UNWRAP -- we just made sure it's not nil
            
            try await offlineTimeLeaderboard.submitScore(
                offlineTimeLeaderboardScore,
                context: 0,
                player: GKLocalPlayer.local
            )
            
            print("🎮 Submitted score \(offlineTimeLeaderboardScore) to game center")
            
        } catch {
            print("🎮 Error updating GK score: \(error)")
            self.error = error.localizedDescription
        }
    }
    
    
}
