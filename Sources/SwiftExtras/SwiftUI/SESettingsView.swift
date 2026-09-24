//
//  SESettingsView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(PreferenceKit)
import SwiftUI

@_exported import PreferenceKit

/// SwiftExtras Settings View.
///
/// Use `PreferenceKit` instead. This compatibility wrapper preserves the
/// `SESettingsView` initializer API while forwarding its content to PreferenceKit.
@available(*, deprecated, renamed: "PreferenceKit", message: "Use PreferenceKit instead.")
public struct SESettingsView<TopContent: View, BottomContent: View>: View {
    private let createdBy: String?
    private let privacyPolicyURL: URL?
    private let supportEmail: String?
    private let socialMediaLinks: [SocialMediaLink]
    private let OSLogSubsystem: String?
    private let changeLog: [SEChangeLogEntry]?
    private let acknowledgements: [SEAcknowledgement]?
    private let customTopSection: () -> TopContent?
    private let customBottomSection: () -> BottomContent?

    /// Initializes SwiftExtras Settings View.
    public init(
        createdBy: String? = nil,
        privacyPolicyURL: URL? = nil,
        supportEmail: String? = nil,
        twitterHandle: String? = nil,
        blueskyHandle: String? = nil,
        mastodonHandle: String? = nil,
        OSLogSubsystem: String? = AppInfo.bundleIdentifier,
        changeLog: [SEChangeLogEntry]?,
        acknowledgements: [SEAcknowledgement]?,
        @ViewBuilder topContent: @escaping () -> TopContent? = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent? = { EmptyView() }
    ) {
        self.createdBy = createdBy
        self.privacyPolicyURL = privacyPolicyURL
        self.supportEmail = supportEmail
        self.socialMediaLinks = Self.socialMediaLinks(
            twitterHandle: twitterHandle,
            blueskyHandle: blueskyHandle,
            mastodonHandle: mastodonHandle
        )
        self.OSLogSubsystem = OSLogSubsystem
        self.changeLog = changeLog
        self.acknowledgements = acknowledgements
        self.customTopSection = topContent
        self.customBottomSection = bottomContent
    }

    /// Internal: Initializes SwiftExtras Settings View with default parameters.
    public init(
        _changeLog: [SEChangeLogEntry]?,
        // swiftlint:disable:previous identifier_name
        _acknowledgements: [SEAcknowledgement]?,
        // swiftlint:disable:previous identifier_name
        @ViewBuilder topContent: @escaping () -> TopContent? = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent? = { EmptyView() }
    ) {
        self.createdBy = "[Wesley de Groot](https://wesleydegroot.nl)"
        self.privacyPolicyURL = URL(
            string: "https://wesleydegroot.nl/apps/\(AppInfo.appName.slugified)/privacy/"
        )
        self.supportEmail = "email+\(AppInfo.appName.slugified)@wesleydegroot.nl"
        self.socialMediaLinks = [
            .init(platform: .x, profile: "0xWDG"),
            .init(platform: .bluesky, profile: "0xwdg.bsky.social"),
            .init(platform: .mastodon, profile: "@0xWDG@mastodon.social"),
            .init(platform: .website, profile: "https://wesleydegroot.nl")
        ]
        self.OSLogSubsystem = "nl.wesleydegroot"
        self.changeLog = _changeLog
        self.acknowledgements = _acknowledgements
        self.customTopSection = topContent
        self.customBottomSection = bottomContent
    }

    /// The application settings and support information.
    public var body: some View {
        PreferenceKit(
            createdBy: createdBy,
            privacyPolicyURL: privacyPolicyURL,
            supportEmail: supportEmail,
            socialMediaLinks: socialMediaLinks,
            OSLogSubsystem: OSLogSubsystem,
            changeLog: preferenceKitChangeLog,
            acknowledgements: preferenceKitAcknowledgements,
            topContent: customTopSection,
            bottomContent: customBottomSection
        )
    }

    private var preferenceKitChangeLog: [ChangeLogEntry]? {
        changeLog?.map { entry in
            var preferenceKitEntry = ChangeLogEntry(
                version: entry.version,
                text: LocalizedStringKey(stringLiteral: entry.text)
            )
            preferenceKitEntry.date = entry.date
            return preferenceKitEntry
        }
    }

    private var preferenceKitAcknowledgements: [Acknowledgement]? {
        acknowledgements?.map {
            Acknowledgement(
                name: $0.name,
                copyright: $0.copyright,
                licence: $0.licence,
                url: $0.url
            )
        }
    }

    private static func socialMediaLinks(
        twitterHandle: String?,
        blueskyHandle: String?,
        mastodonHandle: String?
    ) -> [SocialMediaLink] {
        [
            twitterHandle.map { .init(platform: .x, profile: $0) },
            blueskyHandle.map { .init(platform: .bluesky, profile: $0) },
            mastodonHandle.map { .init(platform: .mastodon, profile: $0) }
        ]
        .compactMap { $0 }
    }
}
#endif
