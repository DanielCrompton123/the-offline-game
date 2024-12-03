//
//  AccountCreationUsernameView.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/1/24.
//
/*
import SwiftUI
import PhotosUI


struct AccountCreationImageView: View {
    
    @Environment(UserAccountViewModel.self) private var accountViewModel
    @State private var chosenImage: PhotosPickerItem?
    @State private var choosingImage = false
    @State private var takingImage = false
    
    private let imageSize: CGFloat = 162
    
    var body: some View {
        
        @Bindable var accountViewModel = accountViewModel
        
        VStack(spacing: 30) {
            
            // PROFILE IMAGE IS THE THIRD OF 3 ACCOUNT-CREATION STEPS
            // NAVIGATE TO EACH
            
            // HEADER
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("CHOOSE A PROFILE")
                    .font(.main30)
                
                Text("PICTURE")
                    .font(.display88)
            }
            
            Group {
                // IMAGE
                if let image = accountViewModel.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: imageSize, height: imageSize)
                } else {
                    Circle()
                        .stroke(.accent, style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round,
                            dash: [0.01, 15]
                        ))
                        .frame(width: imageSize, height: imageSize)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                
                // CHOOSE PHOTO BUTTON
                pictureButton(label: "Select image",
                              systemImage: "photo.circle.fill") {
                    choosingImage = true
                }
            }
            .overlay(alignment: .bottomLeading) {
                
                // TAKE PHOTO BUTTON (opens camera)
                pictureButton(label: "Take a photo",
                              systemImage: "camera.circle.fill") {
                    takingImage = true
                }
            }
            
            
            Spacer()
            
            Button("CONTINUE") {
                
            }
            .buttonStyle(FilledRedButtonStyle(horizontalContentMode: .fit))
            .disabled(accountViewModel.image == nil)
            
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $takingImage) {
            CameraView(uiImage: $accountViewModel.uiImage)
                .ignoresSafeArea()
        }
        .photosPicker(isPresented: $choosingImage,
                      selection: $chosenImage,
                      matching: .any(of: [.images, .screenshots]))
        .onChange(of: chosenImage) { oldValue, newValue in
            Task {
                // Convert the photos picker item to a UIImage
                if let chosenImage,
                   let data = try? await chosenImage.loadTransferable(type: Data.self) {
                    accountViewModel.uiImage = UIImage(data: data)
                }
            }
        }
        .onDisappear {
            // reset them. THIS MAKES NAVIGATING BACK FROM THI SCREEN THEN TO IT AGAIN CLEAR THE IMAGE
            accountViewModel.uiImage = nil
            chosenImage = nil
        }
        
    }
    
    
    
    @ViewBuilder private func pictureButton(label: String, systemImage: String, action: @escaping () -> ()) -> some View {
        Button(label, systemImage: systemImage, action: action)
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
            .font(.system(size: 48))
            .background(.background, in: Circle()) // The + cutout of the circle (in the image) lets the dots show -- it looks bad.
    }
    
}

#Preview {
    AccountCreationImageView()
        .environment(UserAccountViewModel())
}
*/
