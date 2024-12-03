//
//  TipViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/3/24.
//

import Foundation
import Intents


@Observable
class TipViewModel {
    
    // Store wether the user in in focus mode
    var focusModeIsOn: Bool?
    
    // Store wether the user has airplane mode turned on
    var airplaneModeIsOn: Bool?
    
    
    //MARK: - Focus state center
        
    // Ask the user for permission to use the focus state center
    func getFocusStateCenterPermission() {
        INFocusStatusCenter.default.requestAuthorization { status in
            if status == .authorized {
                
            }
        }
    }
}
