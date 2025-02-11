//
//  NetworkMonitor.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/30/24.
//

import Foundation
import ConnectivityKit


@Observable
class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    
    private let connectivityMonitor = ConnectivityMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor.workerQueue")
    
    var isConnected = false
    
    
    func startListening() {
        connectivityMonitor.start(pathUpdateQueue: workerQueue) { [weak self] path in
            print("🛜 Network connectivity updated")
            self?.isConnected = path.status == .satisfied
        }
    }
    
    func stopListening() {
        connectivityMonitor.cancel()
    }
    
}
