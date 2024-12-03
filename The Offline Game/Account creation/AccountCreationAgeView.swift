//
//  AccountCreationAgeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI

struct AccountCreationAgeView: View {
    
    @Environment(UserAccountViewModel.self) private var accountViewModel
    @State private var showsNextStage = false
    
    var body: some View {
        NavigationStack {
            
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
                    accountViewModel.age = .adult
                    showsNextStage = true
                }
                
                Button("I'M OVER 13 YEARS OLD") {
                    accountViewModel.age = .teen
                    showsNextStage = true
                }
                
                Button("I'M A KID, UNDER 13") {
                    accountViewModel.age = .child
                    showsNextStage = true
                }
                
            }
            .buttonStyle(FilledRedButtonStyle())
            
            .padding(.horizontal)
            .navigationDestination(isPresented: $showsNextStage) {
                AccountCreationUsernameView()
            }
        }
    }
}

#Preview {
    AccountCreationAgeView()
        .environment(UserAccountViewModel())
}
