//
//  AccountCreationAgeView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI


enum Age {
    case adult, teen, child
}


struct AccountCreationAgeView: View {
    
    @State private var age: Age?
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
                
                Button {
                    age = .adult
                    showsNextStage = true
                } label: {
                    HStack {
                        Spacer()
                        Text("I'M AN ADULT, DAMNIT!")
                        Spacer()
                    }
                }
                
                Button {
                    age = .teen
                    showsNextStage = true
                } label: {
                    HStack {
                        Spacer()
                        Text("I'M OVER 13 YEARS OLD")
                        Spacer()
                    }
                }
                
                Button {
                    age = .child
                    showsNextStage = true
                } label: {
                    HStack {
                        Spacer()
                        Text("I'M A KID, UNDER 13")
                        Spacer()
                    }
                }
                
            }
            .buttonStyle(FilledRedButtonStyle())
            .navigationTitle("STEP 1/3")
            .navigationBarTitleDisplayMode(.inline)
            
            .padding(.horizontal)
            .navigationDestination(isPresented: $showsNextStage) {
                AccountCreationUsernameView()
            }
        }
    }
}

#Preview {
    AccountCreationAgeView()
}
