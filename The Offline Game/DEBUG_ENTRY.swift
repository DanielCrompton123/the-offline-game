//
//  DEBUG_ENTRY.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI


let IS_DEBUG = false


struct DEBUG: View {

    @State private var score = 20
    @State var ldbVM = GameKitLeaderboardViewModel()
    @State var gkVM = GameKitViewModel()
    
    
    var body: some View {
        
        VStack {
            Button("Add 10 secs") {
                
                Task {
                    score += 10
                    
//                    Task {
//                        await gkVM.leaderboardViewModel?.handle(.offlineTimeFinished(successful: true, .seconds(score)))
//                    }
                    
                }
            }
        }
        .onAppear {
            gkVM.leaderboardViewModel = ldbVM
            gkVM.authenticatePlayer()
            gkVM.openAccessPoint()
        }
        .onChange(of: gkVM.gameCenterEnabled) { oldValue, newValue in
            if newValue == true {
                Task {
                    await gkVM.leaderboardViewModel?.loadLeaderboards()
                }
            }
        }

    }
}



#Preview("DEBUG") {
    DEBUG()
}

