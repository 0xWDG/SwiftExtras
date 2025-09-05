//
//  String+HTML.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension String {
    /// Checks if the string contains HTML tags.
    public var containsHTML: Bool {
        self.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil
    }

    #if canImport(UIKit) && !os(watchOS)
    /// Converts the HTML string to an `NSAttributedString`.
    public func htmlToAttrinbutedString() -> NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .body) // caption1 seems the best (for now)
        let newDescription = "<!DOCTYPE html><meta charset=\"UTF-8\"><style>*{font-family: -apple-system;font-size:\(font.pointSize)px;}</style>\(self)"
        // swiftlint:disable:previous line_length

        if description.containsHTML,
           let data = newDescription.data(using: .utf8),
           let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .defaultAttributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: UIColor.label
                ]
            ],
            documentAttributes: nil
           ) {
            let attributes: [NSAttributedString.Key: AnyObject] = [.foregroundColor: UIColor.label]
            attributedString.addAttributes(
                attributes,
                range: NSRange(
                    location: 0, length: attributedString.length
                )
            )
            return attributedString
        }

        return NSAttributedString(string: self)
    }
    #endif
}
