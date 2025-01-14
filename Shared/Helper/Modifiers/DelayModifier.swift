//
//  DelayModifier.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/10/25.
//

import SwiftUI
import Combine

struct DelayModifier: ViewModifier {
    let time: DispatchTime
    let action: (() -> ())?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: time) {
                    action?()
                }
            }
    }
}

extension View {
    @ViewBuilder func delay(time: DispatchTime, action: (() -> ())?) -> some View {
        modifier(DelayModifier(time: time, action: action))
    }
}
