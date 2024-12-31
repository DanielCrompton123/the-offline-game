//
//  NetworkMonitor.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 12/30/24.
//

import Foundation
import Network


@Observable
class NetworkMonitor {
    
    private init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
    }
    
    static let shared = NetworkMonitor()
    
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor.workerQueue")
    
    var isConnected = false
    
    
    func startListening() {
        networkMonitor.start(queue: workerQueue)
    }
    
    func stopListening() {
        networkMonitor.cancel()
    }
    
}
