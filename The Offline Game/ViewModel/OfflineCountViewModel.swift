//
//  OfflineCountViewModel.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 1/4/25.
//

import Foundation
import FirebaseDatabase

@Observable
class OfflineCountViewModel {
    
    var count = 0
    
    private var realtimeDB: DatabaseReference!
    
    func loadDatabase() {
        realtimeDB = Database.database().reference()
    }
    
    func setupDatabaseObserver() {
        let countRef = realtimeDB.child("offlineCount")
        
        countRef.observe(.value) { [weak self] snapshot in
            if let c = snapshot.value as? Int {
                print("Count changed")
                
                DispatchQueue.main.async {
                    self?.count = c
                }
            } else {
                print("Cannot get Int value from snapshot")
            }
        }
    }
    
    func increase() {
        let countRef = realtimeDB.child("offlineCount")
        
        // The transactions are good for concurrency
        countRef.runTransactionBlock { data in
            data.value = (data.value as? Int ?? 0) + 1
            return .success(withValue: data)
        }
    }
    
    func decrease() {
        let countRef = realtimeDB.child("offlineCount")
        
        // The transactions are good for concurrency
        countRef.runTransactionBlock { data in
            data.value = (data.value as? Int ?? 0) - 1
            return .success(withValue: data)
        }
    }
}
