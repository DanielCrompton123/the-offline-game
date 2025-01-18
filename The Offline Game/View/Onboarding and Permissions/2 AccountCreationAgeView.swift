//
//  AccountCreationAgeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//



import SwiftUI

struct AccountCreationAgeView: View {
        
    @AppStorage(K.userDefaultsUserAgeRawValueKey) private var userAgeRawValue: Int?
    @Environment(\.colorScheme) private var colorScheme
    
    var action: () -> () = { }
        
    var body: some View {
            
        VStack {
            
            Spacer()
            
            // HEADER
            
            ZStack(alignment: .bottom) {
                Image(.dadWithChild)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .scaleEffect(1.3)
                    .foregroundStyle(.smog)
                    .opacity(colorScheme == .light ? 0.1 : 0.4) // it's too hard to see the symbol in dark mode at 0.1
                    .rotationEffect(.degrees(-7))
                
                VStack {
                    HStack {
                        Text("HOW")
                            .font(.main20)
                        Text("OLD")
                            .font(.display128)
                        Text("ARE YOU?")
                            .font(.main20)
                    }
                    
                    Text("(WE’VE GOT TO ASK, FOR LEGAL REASONS)")
                        .font(.main14)
                        .foregroundStyle(.smog)
                }
            }
            
            Spacer()
            
            // AGE BUTTONS
            
            ageSelection(.adult, text: "I'M AN ADULT, DAMNIT!")
            
            ageSelection(.teen, text: "I'M OVER 13 YEARS OLD")
            
            ageSelection(.child, text: "I'M A KID, UNDER 13")
            
        }
        .buttonStyle(FilledRedButtonStyle())
        
    }
    
    
    @ViewBuilder private func ageSelection(_ age: Age, text: String) -> some View {
        Button(text) {
            userAgeRawValue = age.rawValue
            action()
        }
        .tint(
            // If the current age has been selected make this button tint green
            userAgeRawValue == age.rawValue ? .green : .accentColor
        )
        
        .animation(.easeOut(duration: 0.2), value: userAgeRawValue)
    }
}

#Preview {
    AccountCreationAgeView()
}
