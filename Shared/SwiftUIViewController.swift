//
//  SwiftUIViewController.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI


// Embed a UIKit view controller inside a SwiftUI context

struct SwiftUIViewController: UIViewControllerRepresentable {
    
    let controller: UIViewController
    var configure: (UIViewController) -> () = { _ in }
    var update: (UIViewController) -> () = { _ in }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = self.controller
        configure(controller)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        update(controller)
    }
    
}
