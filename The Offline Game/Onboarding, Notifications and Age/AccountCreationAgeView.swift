//
//  AccountCreationAgeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//



import SwiftUI

struct AccountCreationAgeView: View {
    
    @AppStorage("userAgeRawValue") private var userAgeRawValue: Int?
    
    @State private var navigateToNotificationPermissionsView = false
        
    var body: some View {
            
        VStack {
            
            // AGE INPUT IS THE FIRST OF 3 ACCOUNT-CREATION STEPS
            // NAVIGATE TO EACH
            
            Spacer()
            
            // HEADER
            
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
            
            Spacer()
            
            // AGE BUTTONS
            
            Button("I'M AN ADULT, DAMNIT!") {
                userAgeRawValue = Age.adult.rawValue
                navigateToNotificationPermissionsView = true
            }
            
            Button("I'M OVER 13 YEARS OLD") {
                userAgeRawValue = Age.teen.rawValue
                navigateToNotificationPermissionsView = true
            }
            
            Button("I'M A KID, UNDER 13") {
                userAgeRawValue = Age.child.rawValue
                navigateToNotificationPermissionsView = true
            }
            
        }
        .buttonStyle(FilledRedButtonStyle())
        
        .padding(.horizontal)
        .navigationDestination(isPresented: $navigateToNotificationPermissionsView) {
            NotificationPermissionView()
        }
    }
}

#Preview {
    AccountCreationAgeView()
}
