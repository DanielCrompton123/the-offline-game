//
//  BinaryFloatingPoint extension.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import Foundation


extension BinaryFloatingPoint {
    func rounded(toMultipleOf multiple: Self) -> Self {
        guard multiple != 0 else { return self } // Avoid division by zero
        
        let remainder = self.truncatingRemainder(dividingBy: multiple)
        let half = multiple / 2

        if remainder == 0 {
            return self
        } else if remainder >= half {
            return self + (multiple - remainder) // Round up
        } else {
            return self - remainder // Round down
        }
    }
}
