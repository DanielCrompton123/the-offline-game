//
//  OfflineHeader.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 11/30/24.
//

import SwiftUI

struct OfflineHeader: View {
    var body: some View {
        
        VStack(spacing: 10) {
            Image(.offlineIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 260)
            #warning("Remove white background from logo & make a dark version")
            
            HStack(spacing: 2) { // adjust spacing to meet the spacing betwene characters here
                Text("THE")
                    .font(.main26)
                
                Text("OFFLINE")
                    .font(.display108)
                
                Text("GAME")
                    .font(.main26)
            }
        }
        .textCase(.uppercase) // make sure any changes to text above ^ are still upper cased
//        .fixedSize(horizontal: true, vertical: false) // don't truncate or wrap onto new line. Ignore parent container
        .minimumScaleFactor(0.6) // allow header to scale down on smaller screens
        .lineLimit(1)
    }
}

#Preview {
    OfflineHeader()
}
