//
//  Binding extension.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import SwiftUI


extension Binding {
    func condition(_ expr: @escaping (Value) -> Bool) -> Binding<Bool> {
        Binding<Bool> {
            expr(wrappedValue)
        } set: { _ in
        }
    }
    
    
    func condition(_ path: KeyPath<Value, Bool>, inverse: Bool = false) -> Binding<Bool> {
        Binding<Bool> {
            inverse ? !wrappedValue[keyPath: path] : wrappedValue[keyPath: path]
        } set: { val in
        }

    }
}
