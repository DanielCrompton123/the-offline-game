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
    
    
    func loadAchievements() {

        print("loadAchievements called")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Load all the in-progress achievements
            GKAchievement.loadAchievements { achievements, error in
                
                DispatchQueue.main.async {
                    
                    print("Loaded achievements...")
                    
                    // Handle the error
                    if let error {
                        print("Error loading achievements: \n\(error)")
                        self?.error = error.localizedDescription
                        return
                    }
                    
                    // Now assign the variable
                    print("\((achievements ?? []).count) achievements loaded")
                    self?.inProgressAchievements = achievements ?? []
                    
                }
            }
        }
        
    }
    
    
    func reportProgress(_ progress: Double, for achievement: OfflineAchievement) {
                
        // First, check if the achievement is in progress by user (in the inProgressAchievements array).
        // IF SO, set the new progress for it and report the change
        // IF NOT, create a new achievement with the achievement ID and report that
        
        let gkAchievement: GKAchievement
        
        if let inProgressAchievement = inProgressAchievements.first(where: { $0.identifier == achievement.id }) {
            print("In progress achievement found: \(inProgressAchievement.percentComplete)%")
            gkAchievement = inProgressAchievement
        }
        
        else {
            gkAchievement = GKAchievement(identifier: achievement.id)
            print("No achievement for \(achievement.id), so we created one!")
            
            // Now add it to the array
            inProgressAchievements.append(gkAchievement)
        }
        
        // Now change the percentage complete
        gkAchievement.percentComplete = progress
        
        print("gkAchievement.percentComplete now = \(gkAchievement.percentComplete)")
        
        // Now report the change
        GKAchievement.report([gkAchievement]) { [weak self] error in
            print("Reported progress change with error:\n\(String(describing: error))")
            self?.error = error?.localizedDescription
        }
        
    }
    
    func clearAchievements() {
        // https://developer.apple.com/documentation/gamekit/gkachievement/resetachievements(completionhandler:)
        
        DispatchQueue.global(qos: .userInitiated).async {
            GKAchievement.resetAchievements { [weak self] error in
                
                DispatchQueue.main.async {
                    print("Reset achievements with error\n \(String(describing: error))")
                    self?.error = error?.localizedDescription
                }
            }
        }
    }
    
}
