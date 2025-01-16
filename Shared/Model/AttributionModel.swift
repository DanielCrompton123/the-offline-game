//
//  AttributionModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/16/25.
//

import Foundation

struct AttributionModel: Decodable, Hashable {
    let category: String
    let attributions: [String]
}
