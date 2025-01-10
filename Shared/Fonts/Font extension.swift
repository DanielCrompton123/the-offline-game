//
//  Font extension.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI


// extend the Font (from swift ui) to contain all the app's fonts


extension Font {
    static let display256 = Font.custom("Maquire", size: 256)
    static let display108 = Font.custom("Maquire", size: 108)
    static let display128 = Font.custom("Maquire", size: 128)
    static let display88 = Font.custom("Maquire", size: 88)
    static let display40 = Font.custom("Maquire", size: 40)
    static let display28 = Font.custom("Maquire", size: 28)
    
    static let main26 = Font.custom("RobotoCondensed-Bold", size: 26)
    static let main20 = Font.custom("RobotoCondensed-Bold", size: 20)
    static let main30 = Font.custom("RobotoCondensed-Bold", size: 30)
    static let main14 = Font.custom("RobotoCondensed-Bold", size: 14)
    static let main54 = Font.custom("RobotoCondensed-Bold", size: 54)
}
