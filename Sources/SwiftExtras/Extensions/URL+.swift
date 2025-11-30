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

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URL {
    /// Initialize if there might be a scheme provided
    /// if this fails the function will try the `https` scheme.
    ///
    /// - Prameter safeString: The string which may contains a scheme.
    public init?(safeString urlString: String) {
        if urlString.contains("://") {
            self.init(string: urlString)
        } else {
            self.init(string: "https://\(urlString)")
        }
    }

    /// Is the URL valid for being a website (contains a scheme and host)
    public var isWebURL: Bool {
        // Check if we have a scheme (before ://)
        self.scheme != nil &&
        // Check if we have a host
        self.host() != nil
    }

    /// Is the URL valid for being a website (contains a scheme and host)
    public var isValid: Bool {
        self.isWebURL
    }

    /// Check if the URL is reachable by performing a HEAD request.
    /// - Returns: A Boolean value indicating whether the URL is reachable.
    public func isReachable() async -> Bool {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"

        do {
            let (_, response) = try await URLSession.ignoreCertificateErrors.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }

    /// Check if the URL is reachable by performing a HEAD request.
    /// - Parameters:
    ///   - completion: A closure that is called with the result of the request.
    public func isReachable(completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.ignoreCertificateErrors.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }
        .resume()
    }
}
