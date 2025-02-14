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
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Load all the in-progress achievements
            GKAchievement.loadAchievements { achievements, error in
                
                DispatchQueue.main.async {
                                        
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
    
    
//    func reportProgress(_ progress: Double, for achievement: OfflineAchievement) {
//        
//        // First, check if the achievement is in progress by user (in the inProgressAchievements array).
//        // IF SO, set the new progress for it and report the change
//        // IF NOT, create a new achievement with the achievement ID and report that
//        
//        let gkAchievement: GKAchievement
//        
//        if let ach = inProgressAchievements.first(where: {
//            $0.identifier == achievement.id
//        }) {
//            gkAchievement = ach
//        } else {
//            gkAchievement = GKAchievement(identifier: achievement.id)
//            inProgressAchievements.append(gkAchievement)
//        }
//        
//        // Now calculate the list of achievement progresses.
//        // E.g. for 250% it would be 100% / 100% / 50%
//        let num100Pct: Int = Int(progress) / Int(100)
//        print("Inside \(progress) is \(num100Pct) 100%s")
//        // Now find the remainder -- this is the in-progress-achievement progress - remainder
//        // E.g. if we already has 25% progress, remainder would be 50% - 25% = 25%.
////        let remainder =
//        
////        // Now change the percentage complete
////        gkAchievement.percentComplete = progress
////                
////         Now report the change
////        GKAchievement.report([gkAchievement]) { [weak self] error in
////            print("Reported progress change with error:\n\(String(describing: error))")
////            self?.error = error?.localizedDescription
////        }
//        
//    }
    
    /*
     {
         // E.g. 0% to 50%
         // First, check if the achievement is in progress by user (in the inProgressAchievements array).
         // IF NOT, create a new achievement with the achievement ID and report that
         
         // E.g. 50% -> 100% & 20% & achievable multiple times
         // Find in-progress achievement (with 50% progress)
         //      Report 100% progress for it
         //      Create a NEW achievement with a 20% progress
         
         // E.g. 0% -> 233% (achievable multiple times)
         // Find in progress achievement... XXX
         // Create new achievement
         // ProgressES = 100% & 100% & 33%
         // For each progress, create achievement & report
         
         // E.g. 50% -> 275% (achievable multiple times)
         // Find in progress achievement
         // 275 int div 100 = 2
         // This means 2 100% progresses
         // Remainder 75% - in-progress-achievement-progress(50) = 25%
         // In progress achievement progress = 100%
         // Progresses.append( 25%)
         
         let gkAchievement = inProgressAchievements.first {
             $0.identifier == achievement.id
         } ?? GKAchievement(identifier: achievement.id)
         
         // Now add it to the array
         inProgressAchievements.append(gkAchievement)
         
         // IF WE CAN ACHIEVE MULTIPLE TIMES
 //        if gkAchievement.
         
         
     }
     */
    
    
    func reportProgress(_ progress: Double, for achievement: OfflineAchievement) {
        
        // First, check if there is any achievements IN PROGRESS by the user
        // This means achievements that are NOT complete
        // If there ARE NOT then create one
        let gkAchievement: GKAchievement
        
        if let inProgressAch = inProgressAchievements.first(where: {
            $0.identifier == achievement.id && !$0.isCompleted
        }) {
            gkAchievement = inProgressAch
        } else {
            gkAchievement = GKAchievement(identifier: achievement.id)
            inProgressAchievements.append(gkAchievement)
        }
        
        // If the new progress > 100, then we need to find the progress required to complete the in-progress achievement.
        // Then, we can use the remaining progress to award more achievements
        
        // Counter variable to accumulate the new progress
        var newProgress = progress
        
        // Variable to accumulate new achievements that have been changed and NEED TO BE REPORTED
        var modifiedAchievements = [gkAchievement]
        
        if newProgress > 100 {
            
            // Now find the progress required to conmplete the in-progress achievement
            let completionProgress = 100 - gkAchievement.percentComplete
            
            // Now deduct the value from the newProgress to account for completing the in-progress achievement
            newProgress -= completionProgress
            
            // Now complete this achievement
            gkAchievement.percentComplete = 100
            
            // Now we need to create more achievements for the remaining part of the progress (e.g. progress may be 250% so we should create 2 more achievements)
            
            while Int(newProgress) / 100 > 0 {
                // e.g. 225 int div 100 = 2 (>0), 125 int div 100 = 1 (>0)
                // But 25 int div 100 = 0 (not >0)
                
                // Create an achievement, add it to the in-progress array, and the new achievemenrs array
                let newAch = GKAchievement(identifier: achievement.id)
                
                newAch.percentComplete = 100
                modifiedAchievements.append(newAch)
                inProgressAchievements.append(newAch)
                
                // Deduct the percentage off the newProgress
                newProgress -= 100
            }
            
            // Now, the newProgtress WILL BE <100, so create another achievement for it
            let newAchRemainder = GKAchievement(identifier: achievement.id)
            newAchRemainder.percentComplete = newProgress
            modifiedAchievements.append(newAchRemainder)
            inProgressAchievements.append(newAchRemainder)
            newProgress = 0
        }
        
        // If the new progress <= 100% all we need to do is set the in-progress value
        else {
            gkAchievement.percentComplete = newProgress
        }
        
        // LASTLY, report the progress
        GKAchievement.report(modifiedAchievements) { [weak self] error in
            if let error {
                self?.error = error.localizedDescription
            }
        }
        
    }
    
    
    
    func clearAchievements() {
        // https://developer.apple.com/documentation/gamekit/gkachievement/resetachievements(completionhandler:)
        
        inProgressAchievements = []
        
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
