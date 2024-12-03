//
//  AccountCreationUsernameView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//

import SwiftUI


struct Line: Shape {
    var axis: Axis = .horizontal
    
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: rect.origin)
            if axis == .horizontal {
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            } else {
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            }
        }
    }
}


struct AccountCreationUsernameView: View {
    
    @Environment(UserAccountViewModel.self) private var accountViewModel
    @FocusState private var usernameFieldFocused: Bool
    @State private var usernameIsValid = false
    
    @State private var nextStageShows = false
    
    var body: some View {
        
        @Bindable var accountViewModel = accountViewModel
        
        
        VStack(spacing: 30) {
            
            // USERNAME IS THE SECOND OF 3 ACCOUNT-CREATION STEPS
            // NAVIGATE TO EACH
                        
            // HEADER
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("CHOSE YOUR")
                    .font(.main30)
                
                Text("USERNAME")
                    .font(.display88)
                
                Text("USING YOUR INSTAGRAM HANDLE IS EASIEST")
                    .font(.main14)
                    .foregroundStyle(.smog)
            }
                                    
            // TEXT FIELD
            
            VStack(spacing: 4) {
                TextField("USERNAME", text: $accountViewModel.username)
                    .font(.main30)
                    .multilineTextAlignment(.center)
                    .focused($usernameFieldFocused)
                    .onSubmit(validateUsername)
                
                Line()
                    .stroke(.accent, style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round,
                        dash: [0.01, 14]
                    ))
                    .frame(height: 0.1)
                
                if usernameIsValid {
                    Text("YUP, THAT USERNAME IS AVAILABLE")
                        .font(.main14)
                        .foregroundStyle(.smog)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button("CONTINUE") {
                
            }
            .disabled(usernameIsValid)
            .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
            
        }
        .onAppear {
            usernameFieldFocused = true
        }
        .padding(.horizontal)
        .navigationDestination(isPresented: $nextStageShows) {
            AccountCreationImageView()
        }
    }
    
    
    private func validateUsername() {
        usernameIsValid = true
        
        // Give user half a second to read extra text that was added to the UI if the username is valid
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            nextStageShows = true
        }
    }
}

#Preview {
    AccountCreationUsernameView()
}
