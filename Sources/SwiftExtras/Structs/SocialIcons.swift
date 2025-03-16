//
//  SocialIcons.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Social Icons
///
/// A collection of social icons
public enum SocialIcons {
    /// Bluesky icon
    public static let bluesky = Image("bluesky", bundle: Bundle.module)

    /// Discord icon
    public static let discord = Image("discord", bundle: Bundle.module)

    /// Discord icon (filled)
    public static let discordFill = Image("discord.fill", bundle: Bundle.module)

    /// Discourse icon
    public static let discourse = Image("discourse.fill", bundle: Bundle.module)

    /// Facebook icon
    public static let facebook = Image("facebook", bundle: Bundle.module)

    /// Github icon
    public static let github = Image("github", bundle: Bundle.module)

    /// Instagram icon
    public static let instagram = Image("instagram", bundle: Bundle.module)

    /// LinkedIn icon
    public static let linkedin = Image("linkedin", bundle: Bundle.module)

    /// Mastodon icon
    public static let mastodon = Image("mastodon", bundle: Bundle.module)

    /// Reddit icon
    public static let reddit = Image("reddit", bundle: Bundle.module)

    /// Reddit icon (filled)
    public static let redditFill = Image("reddit.fill", bundle: Bundle.module)

    /// Slack icon
    public static let slack = Image("slack", bundle: Bundle.module)

    /// Telegram icon
    public static let telegram = Image("telegram", bundle: Bundle.module)

    /// TikTok icon
    public static let tiktok = Image("tiktok", bundle: Bundle.module)

    /// TikTok icon (official)
    public static let tiktokOfficial = Image("tiktok-official", bundle: Bundle.module)

    /// Threads icon
    public static let threads = Image("threads", bundle: Bundle.module)

    /// Twitter icon
    public static let twitter = Image("twitter", bundle: Bundle.module)

    /// X/Twitter icon
    public static let xtwitter = Image("x-twitter", bundle: Bundle.module)

    /// X icon
    public static let x = Image("x-twitter", bundle: Bundle.module)
    // swiftlint:disable:previous identifier_name

    /// YouTube icon
    public static let youtube = Image("youtube", bundle: Bundle.module)

    /// YouTube icon (filled)
    public static let youtubeFill = Image("youtube.fill", bundle: Bundle.module)

    /// A dictionary containing all social images
    public static let dict: [String: Image] = [
        "bluesky": SocialIcons.bluesky,
        "discord": SocialIcons.discord,
        "discordFill": SocialIcons.discordFill,
        "discourse": SocialIcons.discourse,
        "facebook": SocialIcons.facebook,
        "github": SocialIcons.github,
        "instagram": SocialIcons.instagram,
        "linkedin": SocialIcons.linkedin,
        "mastodon": SocialIcons.mastodon,
        "reddit": SocialIcons.reddit,
        "redditFill": SocialIcons.redditFill,
        "slack": SocialIcons.slack,
        "telegram": SocialIcons.telegram,
        "tiktok": SocialIcons.tiktok,
        "tiktokOfficial": SocialIcons.tiktokOfficial,
        "threads": SocialIcons.threads,
        "twitter": SocialIcons.twitter,
        "xtwitter": SocialIcons.xtwitter,
        "youtube": SocialIcons.youtube,
        "youtubeFill": SocialIcons.youtubeFill,
        "x": SocialIcons.x
    ]
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        Form {
            ForEach(Array(SocialIcons.dict.keys).sorted()) { identifier in
                Label {
                    Text(identifier)
                } icon: {
                    SocialIcons.dict[identifier]
                }
            }
        }
        .navigationTitle("Social icons")
    }
}
#endif
#endif
