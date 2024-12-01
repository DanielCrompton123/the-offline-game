//
//  ContentView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Username")
                .font(.display88)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
