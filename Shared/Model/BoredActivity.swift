//
//  BoredActivity.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import Foundation

struct BoredActivity: Codable, Identifiable, Equatable {
    var id: String { key }
    
    let key: String
    let activity: String
    let participants: Int
    let type: String
    
    var systemImage: String {
        // education, recreational, social, charity, cooking, relaxation, busywork
        switch type {
        case "education": "character.book.closed"
        case "recreational": "basketball"
        case "social": "person.line.dotted.person"
        case "charity": "hands.and.sparkles"
        case "cooking": "fork.knife"
        case "relaxation": "figure.yoga"
        case "busywork": "hammer"
        default: "circle"
        }
    }
}
