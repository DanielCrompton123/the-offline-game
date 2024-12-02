//
//  UserAccountViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/2/24.
//

import SwiftUI


@Observable
class UserAccountViewModel {
    var age: Age?
    var username = ""
    
    var uiImage: UIImage?
    
    var image: Image? {
        guard let uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
    
//    var userHasAccount: Bool {
//        age == nil && username.isEmpty && uiImage == nil
//    }
    
    
    init(age: Age? = nil, username: String = "", uiImage: UIImage? = nil) {
        self.age = age
        self.username = username
        self.uiImage = uiImage
    }
    
    init() {
        self.age = Age(rawValue: UserDefaults.standard.integer(forKey: "ageRawValue"))
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        
        if let retrieved = UserDefaults.standard.data(forKey: "profileImagePNGData") {
            self.uiImage = UIImage(data: retrieved)
        } else {
            self.uiImage = nil
        }
    }
    
    
    func save() {
        UserDefaults.standard.set(age?.rawValue, forKey: "ageRawValue")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(uiImage?.pngData(), forKey: "profileImagePNGData")
    }
}
