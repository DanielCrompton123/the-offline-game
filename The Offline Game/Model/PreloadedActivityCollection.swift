//
//  ActivityViewActivityCollection.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import Foundation

struct PreloadedActivityCollection: Codable, Identifiable {
    var id: UUID { UUID() }
    let category: String
    let systemImage: String
    let activities: [Activity]
    
    struct Activity: Codable, Identifiable {
        var id: UUID { UUID() }
        var title: String
        var description: String
    }
    
}
