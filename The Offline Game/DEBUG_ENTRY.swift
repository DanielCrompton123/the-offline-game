//
//  DEBUG_ENTRY.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI


let IS_DEBUG = false


struct DEBUG: View {

    @State private var t = ""
    @State private var t2 = ""
    
    @FocusState private var t1Focused: Bool
    @FocusState private var t2Focused: Bool
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                TextField("Hello", text: $t)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        print("Submitted T1")
                    }
                    .focused($t1Focused)
                
                TextField("Hello", text: $t2)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onSubmit {
                        print("Submitted T2")
                    }
                    .focused($t2Focused)
                
             }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Click!") {
                        
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done", systemImage: "checkmark") {
                        print("DONE PRESSED")
                        t1Focused = false
                        t2Focused = false
                    }
                }
            }
            
        }

    }
}



#Preview("DEBUG") {
    DEBUG()
}

