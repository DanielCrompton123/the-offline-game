//
//  SnapScrollTargetLayout.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/8/25.
//

import SwiftUI


struct SnapScrollTargetBehaviour: ScrollTargetBehavior {
    let step: Double
    
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        
        let oldX = target.rect.origin.x
        
        target.rect.origin.x = closestMultiple(a: oldX, b: step)
        
    }
    
    
    fileprivate func closestMultiple(a: Double, b: Double) -> Double {
        let lowerMultiple = floor(a / b) * b
        let upperMultiple = lowerMultiple + b
        
        return abs(a - lowerMultiple) <= abs(a - upperMultiple) ? lowerMultiple : upperMultiple
    }
    
}



extension ScrollTargetBehavior where Self == SnapScrollTargetBehaviour {
    
    func snap(step: Double) -> SnapScrollTargetBehaviour {
        .init(step: step)
    }
    
}
