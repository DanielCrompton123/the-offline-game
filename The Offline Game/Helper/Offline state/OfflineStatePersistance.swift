//
//  OfflineStatePersistance.swift
//  The Offline Game
//
//  Created by Daniel Crompton on 3/10/25.
//

import Foundation


struct OfflineStatePersistance {
    
    static private let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("persisted-state.json", conformingTo: .json)
    
    static private let encoder = JSONEncoder()
    static private let decoder = JSONDecoder()
    
    
    static func persist(_ state: OfflineState) throws {
        // Make sure that the user is in HARD COMMIT as this is the only time the state should be persisted
        guard state.isHardCommit else {
            print("💽 Offline state is a soft commit so not persisting")
            return
        }
        
        do {
            // Convert it to JSON and save to documents
            let data = try encoder.encode(state)
            
            try data.write(to: fileURL)
            print("💽 Offline state saved to \(fileURL.absoluteString)")
        } catch {
            print("💽 Error saving offline state: \(error)")
            throw error
        }
    }
    
    
    static func restore() throws -> OfflineState? {
        let fileContents = try Data(contentsOf: fileURL)
        let data = try decoder.decode(OfflineState.self, from: fileContents)
        
        print("💽 Restoring previous offline state from file")
        
        // Make sure old files are deleted once recovering (so it's not recovered again next time)
        try FileManager.default.removeItem(at: fileURL)
        return data
    }
}
