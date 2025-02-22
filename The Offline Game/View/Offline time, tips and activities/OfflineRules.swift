//
//  OfflineRules.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 2/22/25.
//

import SwiftUI

struct OfflineRules: View {
    var body: some View {
        
        VStack {
            
            // TITLE
            Text("Rules")
                .font(.display108)
            
            // SCROLL VIEW WITH GRID OF RULES
            ScrollView(.vertical) {
                
                Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                    
                    // Rules:
                    // - Once you go offline, you cannot use other apps
                    // - You must keep the Offline App open
                    // - You may put your phone on standby
                    // - Do NOT power the phone down
                    // - If you close the Offline App, you will be given a 20s grace period to reopen it again
                    
                    GridRow {
                        rule("Once you go offline, you cannot use other apps", icon: "hand.raised.app", alignment: .center, layout: VStackLayout(spacing: 20))
                        
                        rule("To stay offline, keep the app open", icon: "phone", alignment: .center, layout: VStackLayout(spacing: 20))
                    }
                    .frame(height: 200)
                    .multilineTextAlignment(.center)
                    
                    
                    GridRow {
                        rule("You may put your phone into standby mode", icon: "powersleep", alignment: .leading, layout: HStackLayout(spacing: 20))
                    }
                    .frame(height: 80)
                    .multilineTextAlignment(.leading)
                    .gridCellColumns(2)
                    GridRow {
                        rule("Do NOT power the device off", icon: "power.circle.fill", alignment: .leading, layout: HStackLayout(spacing: 20))
                    }
                    .frame(height: 80)
                    .multilineTextAlignment(.leading)
                    .gridCellColumns(2)
                    GridRow {
                        rule("If you close the Offline App, you will be given a 20s grace period to reopen it again", icon: "app.badge.checkmark.fill", alignment: .center, layout: VStackLayout(spacing: 20))
                    }
                    .frame(height: 200)
                    .multilineTextAlignment(.center)
                    .gridCellColumns(2)
                    
                }
                .safeAreaPadding(.horizontal, 30)
                
            }
        }
    }
    
    
    @ViewBuilder private func rule<L: Layout>(_ text: String, icon: String, alignment: Alignment, layout: L) -> some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(.smog.opacity(0.2))
            .overlay(alignment: alignment) {
                
                layout {
                    
                    Image(systemName: icon)
                        .foregroundStyle(.accent)
                        .font(.main30)
                    
                    Text(text)
                        .foregroundStyle(.ruby)
                        .textCase(.uppercase)
                        .font(.main20)
                }
                .padding()
            }
    }
}

#Preview {
    OfflineRules()
}
