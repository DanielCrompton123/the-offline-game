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
    
    static private let achievementScoreLeaderboardID = "achievementsScore"
    static private let offlineTimeLeaderboardID = "offlineTime"
    
    private var leaderboards: [GKLeaderboard] = []
    private var achievementScoreLeaderboard: GKLeaderboard? {
        leaderboards.first { $0.baseLeaderboardID == Self.achievementScoreLeaderboardID }
    }
    private var offlineTimeLeaderboard: GKLeaderboard? {
        leaderboards.first { $0.baseLeaderboardID == Self.offlineTimeLeaderboardID }
    }
    
    
    var error: String?
    
    
    func loadLeaderboards() async {
        print("Loading leaderboards")
        
        do {
            self.leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [Self.achievementScoreLeaderboardID, Self.offlineTimeLeaderboardID])
            
        } catch {
            self.error = error.localizedDescription
            print("Error loading leaderboards: \(error)")
        }
    }
    
    
    func handle(_ event: GameEvent) async {
        
        guard let duration = event.duration else {
            print("Nothing to report to leaderboard for \(event)")
            return
        }
        
        do {
        
            // When the offline time/overtime finishes, we should submit their offline duration to the duration leaderboard:
            try await offlineTimeLeaderboard?.submitScore(
                Int(duration.components.seconds),
                context: 0,
                player: GKLocalPlayer.local
            )
            
            
            #warning("Now get the number of points for the achievements and submit these for the achievementScores leaderboard")
            
        } catch {
            self.error = error.localizedDescription
            print("Could not submit score to leaderboard: \(error)")
        }
                
    }
    
    
}
