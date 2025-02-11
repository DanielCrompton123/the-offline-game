//
//  Achievement.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/20/25.
//

import Foundation


enum OfflineAchievement {
        
    case firstMins(mins: Int),
         total(hrs: Int),
         block(hrs: Int),
         leaderboard(position: Int, weeks: Int),
         periods(num: Int),
         overtime(mins: Int),
         daysRunning(num: Int)
    
    
    var id: String {
        switch self {
        case .firstMins(let mins):
            "First\(mins)Min"
        case .total(let hrs):
            "\(hrs)HrTot"
        case .block(let hrs):
            "\(hrs)HrBlk"
        case .leaderboard(let position, let weeks):
            "\( (1...3).contains(position) ? "12345" : "\(position)" )\( weeks == 0 ? "" : "\(weeks)Wk" )"
        case .periods(let num):
            "\(num)OffPds"
        case .overtime(let mins):
            {
                let isHrs = mins > 60
                return "\( isHrs ? "\(mins * 60)" : "\(mins)" )\( isHrs ? "Hr" : "Min" )Ovt"
            }()
        case .daysRunning(let num):
            "\(num)DaysRunning"
        }
    }
    
    
    var type: AchievementType {
        AchievementType.type(for: self)
    }
    
    
    enum AchievementType: String, Equatable {
        case first, total, block, leaderboard, periods, overtime, daysRunning
        
        static func type(for achievement: OfflineAchievement) -> AchievementType {
            switch achievement {
            case .firstMins: .first
            case .total: .total
            case .block: .block
            case .leaderboard: .leaderboard
            case .periods: .periods
            case .overtime: .overtime
            case .daysRunning: .daysRunning
            }
        }
    }
}
