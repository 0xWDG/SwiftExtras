//
//  URLSession.swift
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

public class IgnoreSSLErrorsDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    /// urlSession(_:didReceive:completionHandler:) - Ignore SSL certificate errors
    /// - Parameters:
    ///   - session: The URLSession instance
    ///   - challenge: The URLAuthenticationChallenge instance
    ///   - completionHandler: The completion handler to call with the disposition and credential.
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge
    ) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
#if os(Linux)
            // No trust APIs on Linux
            return (.performDefaultHandling, nil)
#else
            let cred = challenge.protectionSpace.serverTrust.map { URLCredential(trust: $0) }
            return (.useCredential, cred)
#endif
        default:
            return (.performDefaultHandling, nil)
        }
    }
}

extension URLSession {
    /// A URLSession that ignores SSL certificate errors.
    public static let ignoreCertificateErrors: URLSession = {
        URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: IgnoreSSLErrorsDelegate(),
            delegateQueue: nil
        )
    }()

    /// A URLSession that ignores SSL certificate errors.
    public static let unsafe: URLSession = {
        URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: IgnoreSSLErrorsDelegate(),
            delegateQueue: nil
        )
    }()
}
