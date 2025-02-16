//
//  GameKitAchievementsViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/19/25.
//

import Foundation
import GameKit


@Observable
class GameKitAchievementsViewModel {
        
    weak var gameKitViewModel: GameKitViewModel?
    
    private var inProgressAchievements = [GKAchievement]()
    
    var error: String?
    
    
    func loadAchievements() async {
        
        do {
            let achievements = try await GKAchievement.loadAchievements()
            print("\((achievements).count) achievements loaded")
            
            await MainActor.run {
                self.inProgressAchievements = achievements
            }
        } catch {
            print("Error loading achievements:\n\(error)")
            self.error = error.localizedDescription
        }
        
    }
    
    
    func reportProgress(_ progress: Double, for achievement: OfflineAchievement) async {
        
        // First, check if the achievement is in progress by user (in the inProgressAchievements array).
        // IF SO, set the new progress for it and report the change
        // IF NOT, create a new achievement with the achievement ID and report that
        
        let gkAchievement: GKAchievement
        
        if let ach = inProgressAchievements.first(where: {
            $0.identifier == achievement.id
        }) {
            gkAchievement = ach
        } else {
            gkAchievement = GKAchievement(identifier: achievement.id)
            inProgressAchievements.append(gkAchievement)
        }
                
        // Now change the percentage complete
        gkAchievement.percentComplete = progress
                
        // Now report the change
        print("Reporting \(gkAchievement.percentComplete)% for \(gkAchievement.identifier)")
        
        do {
            try await GKAchievement.report([gkAchievement])
        } catch {
            print("Error reporting achievement: \(error)")
            self.error = error.localizedDescription
        }
        
    }
    
    
    func clearAchievements() async {
        // https://developer.apple.com/documentation/gamekit/gkachievement/resetachievements(completionhandler:)
        
        inProgressAchievements = []

        do {
            try await GKAchievement.resetAchievements()
        } catch {
            print("Reset achievements with error\n \(String(describing: error))")
            self.error = error.localizedDescription
        }
        
        // Clear data that the achievement updaters have
        OfflineAchievementsProgressManager.shared.resetAchievementProgress()
    }
    
}
