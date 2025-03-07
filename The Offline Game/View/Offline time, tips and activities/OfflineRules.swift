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
            Text("How it works")
                .font(.display88)
            
            // SCROLL VIEW WITH GRID OF RULES
            ScrollView(.vertical) {
                
                Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                    
                    // Rules:
                    // - Once you go offline, you cannot use other apps
                    // - You must keep the Offline App open
                    // - You may put your phone on standby
                    // - Do NOT power the phone down
                    // - If you close the Offline App, you will be given a 20s grace period to reopen it again
                    
                    GridRow(alignment: .bottom) {
                        rule("Once you go offline, you cannot use other apps", icon: "hand.raised.app", alignment: .center, layout: VStackLayout(spacing: 20))
                        
                        rule("To stay offline, keep the app open", icon: "phone", alignment: .center, layout: VStackLayout(spacing: 20))
                    }
                    .frame(height: 200)
                    .multilineTextAlignment(.center)
                    
                    
                    GridRow(alignment: .bottom) {
                        rule("You may put your phone into standby mode", icon: "powersleep", alignment: .leading, layout: HStackLayout(spacing: 20))
                    }
                    .frame(height: 80)
                    .multilineTextAlignment(.leading)
                    .gridCellColumns(2)
                    GridRow(alignment: .bottom) {
                        rule("Do NOT power the device off", icon: "power.circle.fill", alignment: .leading, layout: HStackLayout(spacing: 20))
                    }
                    .frame(height: 80)
                    .multilineTextAlignment(.leading)
                    .gridCellColumns(2)
                    GridRow(alignment: .bottom) {
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
        
        
        // LOOKS LIKE BUTTONS:
//        RoundedRectangle(cornerRadius: 20)
//            .fill(.smog.opacity(0.2))
//            .overlay(alignment: alignment) {
//                
//                layout {
//                    
//                    Image(systemName: icon)
//                        .foregroundStyle(.accent)
//                        .font(.main30)
//                    
//                    Text(text)
//                        .foregroundStyle(.ruby)
//                        .textCase(.uppercase)
//                        .font(.main20)
//                }
//                .padding()
//            }
        
        
        VStack(spacing: 0) {
            layout {
                
                Image(systemName: icon)
                    .foregroundStyle(.accent)
                    .font(.main30)
                
                Text(text)
                    .foregroundStyle(.ruby)
                    .textCase(.uppercase)
                    .font(.main20)
                    .minimumScaleFactor(0.2)
            }
            .padding(6)
            
            Capsule()
                .fill(.accent)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OfflineRules()
}
