//
//  HomeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text("\(Text("2,571").foregroundStyle(.ruby)) people are offline right now, competing to see who can avoid their phine the longest.\n\(Text("Up for the challenge?").foregroundStyle(colorScheme == .light ? .black : .white))")
            .textCase(.uppercase)
            .font(.main20)
            .foregroundStyle(.smog)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    HomeView()
}
