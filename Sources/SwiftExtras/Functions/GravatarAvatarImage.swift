//
//  GravatarAvatarImage.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(CryptoKit) && !os(watchOS)
import CryptoKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftUI

/// Errors that can occur while fetching a Gravatar avatar image.
public enum GravatarAvatarImageError: Error, LocalizedError {
    /// The Gravatar avatar URL could not be created.
    case invalidURL
    /// The Gravatar service returned a non-success status code.
    case invalidResponse(Int)
    /// The downloaded data could not be decoded as an image.
    case invalidImageData

    /// A localized description of the error.
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The Gravatar avatar URL could not be created."
        case .invalidResponse(let statusCode):
            return "The Gravatar service returned HTTP status code \(statusCode)."
        case .invalidImageData:
            return "The Gravatar response could not be decoded as an image."
        }
    }
}

/// Fetches a Gravatar avatar image for an email address.
///
/// The email address is normalized by trimming whitespace and lowercasing it,
/// then hashed with SHA256 for Gravatar's avatar endpoint.
///
/// - Parameters:
///   - emailAddress: The email address associated with the Gravatar avatar.
///   - size: The requested square image size in pixels. Defaults to `80`.
///   - defaultImage: The Gravatar default image value used when no avatar exists. Defaults to `"mp"`.
///   - rating: The maximum Gravatar content rating to return. Defaults to `"g"`.
///   - session: The `URLSession` used to fetch the image. Defaults to `.shared`.
/// - Returns: A SwiftUI `Image` created from the fetched avatar data.
/// - Throws: ``GravatarAvatarImageError`` when the URL, HTTP response, or image data is invalid.
public func gravatarAvatarImage(
    emailAddress: String,
    size: Int = 80,
    defaultImage: String = "mp",
    rating: String = "g",
    session: URLSession = .shared
) async throws -> Image {
    let normalizedEmailAddress = emailAddress
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
    let digest = SHA256.hash(data: Data(normalizedEmailAddress.utf8))
    let emailHash = digest.map { String(format: "%02x", $0) }.joined()
    let imageSize = max(1, size)

    var components = URLComponents()
    components.scheme = "https"
    components.host = "gravatar.com"
    components.path = "/avatar/\(emailHash)"
    components.queryItems = [
        URLQueryItem(name: "s", value: "\(imageSize)"),
        URLQueryItem(name: "d", value: defaultImage),
        URLQueryItem(name: "r", value: rating)
    ]

    guard let url = components.url else {
        throw GravatarAvatarImageError.invalidURL
    }

    let (data, response) = try await session.data(from: url)

    if let httpResponse = response as? HTTPURLResponse,
       !(200...299).contains(httpResponse.statusCode) {
        throw GravatarAvatarImageError.invalidResponse(httpResponse.statusCode)
    }

    guard let image = Image(data: data) else {
        throw GravatarAvatarImageError.invalidImageData
    }

    return image
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var image: Image?

    Form {
        Section("Async await") {
            if let image {
                image
            }
        }
        .task {
            image = try? await gravatarAvatarImage(
                emailAddress: "email@wesleydegroot.nl"
            )
        }

        Section("With AsyncView") {
            AsyncView {
                try? await gravatarAvatarImage(
                    emailAddress: "email@wesleydegroot.nl"
                )
            } content: { image in
                image
            }
        }
    }
}
#endif
#endif
