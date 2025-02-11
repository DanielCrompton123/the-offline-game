//
//  Line.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/10/25.
//

import SwiftUI

struct Line: Shape {
    
    let start: UnitPoint
    let end: UnitPoint
    
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            
            // Go to the start point. This is the start unit point * the maxX and same for Y
            path.move(to: CGPoint(
                x: start.x * rect.maxX,
                y: start.y * rect.maxY
            ))
            
            // Now the end point
            path.addLine(to: CGPoint(
                x: end.x * rect.maxX,
                y: end.y * rect.maxY
            ))
        }
    }
}
#Preview {
    Line(start: .leading, end: .trailing)
        .stroke(.black, style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [0.1, 20]))
}
