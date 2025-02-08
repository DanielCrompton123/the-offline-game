//
//  DelayedLottieAnimation.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/12/25.
//

import SwiftUI
import Lottie

struct DelayedLottieAnimation: View {
    
    let name: String
    var endCompletion: CGFloat
    var delay: TimeInterval = 1.5
    
    @State private var shouldPlay = false
    
    var body: some View {
        LottieView(animation: .named(name))
            .playbackMode(shouldPlay ? .playing(.toProgress(endCompletion, loopMode: .playOnce)) : .paused)
            .animationSpeed(0.6)
            .configure { lottieAnimationView in
                lottieAnimationView.contentMode = .scaleAspectFit
            }
            .delay(time: .now() + delay) {
                shouldPlay = true
            }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        
        DelayedLottieAnimation(name: "Lightbulb", endCompletion: 0.8)
            .background {
                Rectangle().stroke(lineWidth: 2)
            }
    }
}
