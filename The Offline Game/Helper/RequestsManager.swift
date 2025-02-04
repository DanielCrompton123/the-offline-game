//
//  RequestsManager.swift
//  DailyWallpapers
//
//  Created by Daniel Crompton on 16/05/2024.
//

import Foundation


struct RequestsManager {
    
    /// Make a request to the URL specified and return data decoded in the format specified
    static func get<T: Decodable>(
        _ url: String,
        parameters: [String:String] = [:],
        headers: [String:String] = [:],
        decodeTo: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        
        // 1. Make URL
        guard let url = URL(string: "\(url)?\(parameters.urlQuery())") else {
            throw URLError(.badURL)
        }
        
        print("Requesting \(url.absoluteString)")
        
        // 2. Make request
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        // 3. Get, return and decode data
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(decodeTo, from: data)
        } catch {
            // If an error happens, print the string of the data that was actually retrieved and then forward the error on
            if let string = String(data: data, encoding: .utf8) {
                print("ERROR decoding data from requesting URL: Data retrieved is:")
                print("\n```\n\(string)\n```\n")
            }
            throw error
        }
    }
    
    
    static func download(
        _ url: String,
        to location: URL,
        parameters: [String:String] = [:],
        headers: [String:String] = [:]
    ) async throws {
        
        // 1. Make URL
        guard let url = URL(string: "\(url)?\(parameters.urlQuery())") else {
            throw URLError(.badURL)
        }
        
        print("Requesting \(url.absoluteString)")
        
        // 2. Make request
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        // 3. Get, and download data
        let (data, _) = try await URLSession.shared.data(for: request)
        try data.write(to: location)

    }
    
}


extension Dictionary where Key == String, Value == String {
    func urlQuery() -> String {
        var s = ""
        for key in self.keys {
            s += key + "=" + self[key]! + "&"
        }
        return s
    }
}
