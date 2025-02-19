//
//  Array.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/18/25.
//

import Foundation


extension Array where Element: Comparable {
    func largestBelowOrEqual(to input: Element) -> Element? {
        return filter { $0 <= input }.max()
    }
}
