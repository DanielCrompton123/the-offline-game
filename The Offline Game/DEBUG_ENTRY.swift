//
//  DEBUG_ENTRY.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/17/25.
//

import SwiftUI


fileprivate struct DEBUG: View {
    
    class TextViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .green
            
            let text = UILabel(frame: CGRect(x: 50, y: 50, width: 200, height: 50))
            text.text = "Hello, World!"
            text.backgroundColor = .red
            view.addSubview(text)
        }
    }
    
    var rootViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first?.rootViewController
    }
    
    
    @State private var p = false
    var body: some View {
        Button("Present") {
//            p = true
            rootViewController?.present(TextViewController(), animated: true)
        }
//        .sheet(isPresented: $p) {
//            SwiftUIViewController(controller: TextViewController())
//        }
    }
}



#Preview("DEBUG") {
    DEBUG()
}

