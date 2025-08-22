//
//  URL+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-08-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftUI

extension URL {
    /// Check if the URL is reachable by performing a HEAD request.
    /// - Returns: A Boolean value indicating whether the URL is reachable.
    public func isReachable() async -> Bool {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }

    /// Check if the URL is reachable by performing a HEAD request.
    /// - Parameters:
    ///   - completion: A closure that is called with the result of the request.
    /// - Returns: A Boolean value indicating whether the URL is reachable.
    public func isReachable(completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }
        .resume()
    }
}
