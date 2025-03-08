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

#if canImport(SwiftUI)
import SwiftUI
#if canImport(OSLog)
import OSLogViewer
#endif
#if canImport(StoreKit)
import StoreKit
#endif
#if canImport(MessageUI)
import MessageUI
#endif

/// SwiftExtras Settings View
///
/// SwiftExtras Settings View is a SwiftUI View that can be used to show information about your app.
/// It can show the app icon, app name, created by, privacy policy, support email, twitter handle,
/// bluesky handle, mastodon handle, app store developer URL, changelog, and additional content.
@available(macOS 13.0, *)
public struct SESettingsView<TopContent: View, BottomContent: View>: View {
    // swiftlint:disable:previous type_body_length
    // MARK: Environment
    @Environment(\.dismiss) var dismiss
#if canImport(StoreKit)
    @Environment(\.requestReview) var requestReview
#endif

#if canImport(MessageUI)
    @State
    private var result: Result<MFMailComposeResult, Error>?
#endif

    @State
    private var isShowingMailView = false

#if canImport(OSLog)
    private var extractor: OSLogExtractor?
#endif

    @State
    private var OSLogString = ""

    @State
    private var isLoading: Bool = false

    @State
    private var reviewURL: URL?

    @State
    private var developerURL: URL?

    // MARK: Custom
    var createdBy: String?
    var privacyPolicyURL: URL?
    var supportEmail: String?
    var twitterHandle: String?
    var blueskyHandle: String?
    var mastodonHandle: String?
    var appStoreDeveloperURL: String?
    var changeLog: [SEChangeLogEntry]?
    var acknowledgments: [SEAcknowledgement]?
    let customTopSection: () -> TopContent?
    let customBottomSection: () -> BottomContent?

    /// Initialize SwiftExtras Settings View
    ///
    /// SwiftExtras Settings View is a SwiftUI View that can be used to show information about your app.
    /// It can show the app icon, app name, created by, privacy policy, support email, twitter handle,
    /// bluesky handle, mastodon handle, app store developer URL, changelog, and additional content.
    ///
    /// - Parameters:
    ///   - createdBy: Your name (supports markdown)
    ///   - privacyPolicyURL: Privacy policy URL.
    ///   - supportEmail: Your support email
    ///   - twitterHandle: Your Twitter / X dandle
    ///   - blueskyHandle: Your Bluesky handle
    ///   - mastodonHandle: Your Mastodon handle
    ///   - OSLogSubsystem: The subsystem for your OS-Logs (nil = hidden), no value = AppBundle
    ///   - changeLog: Changelog
    ///   - acknowledgements: Acknowledgements to mention
    ///   - content: Additional content
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
        self.twitterHandle = twitterHandle
        self.blueskyHandle = blueskyHandle
        self.mastodonHandle = mastodonHandle
        self.changeLog = changeLog
        self.acknowledgments = acknowledgements
        self.customTopSection = topContent
        self.customBottomSection = bottomContent
#if canImport(OSLog)
        if let OSLogSubsystem {
            self.extractor = OSLogExtractor(
                subsystem: OSLogSubsystem,
                since: Date().addingTimeInterval(-900) // 15 minutes max.
            )
        }
#endif
    }

    /// Internal: Initializes SwiftExtras Settings View (with default parameters for my apps)
    public init(
    _changeLog: [SEChangeLogEntry]?,
    // swiftlint:disable:previous identifier_name
    _acknowledgements: [SEAcknowledgement]?,
    // swiftlint:disable:previous identifier_name
    @ViewBuilder topContent: @escaping () -> TopContent? = { EmptyView() },
    @ViewBuilder bottomContent: @escaping () -> BottomContent? = { EmptyView() }
    ) {
        self.createdBy = "[Wesley de Groot](https://wesleydegroot.nl)"
        if let privacyURL = URL(
            string: "https://wesleydegroot.nl/apps/\(AppInfo.appName.slugified)/privacy/"
        ) {
            self.privacyPolicyURL = privacyURL
        }
        self.supportEmail = "email+\(AppInfo.appName.slugified)@wesleydegroot.nl"
        self.twitterHandle = "0xWDG"
        self.blueskyHandle = "0xwdg.bsky.social"
        self.mastodonHandle = "@0xWDG@mastodon.social"
        self.changeLog = _changeLog
        self.acknowledgments = _acknowledgements
        self.customTopSection = topContent
        self.customBottomSection = bottomContent
#if canImport(OSLog)
        self.extractor = OSLogExtractor(
            subsystem: "nl.wesleydegroot",
            since: Date().addingTimeInterval(-900) // 15 minutes max.
        )
#endif
    }

    var getMailBody: String {
        return """
        Hello,\n
        I want to give some feedback/report a bug in \(AppInfo.appName),\n
        ....\n
        - PLEASE DO NOT CHANGE ANYTHING BELOW THIS LINE -\n
        Version: \(AppInfo.versionNumber), \
        Build: \(AppInfo.buildNumber), \
        Environment: \(AppInfo.isTestflight ? "TestFlight" : "AppStore"), \
        iOSAppOnMac: \(AppInfo.isiOSAppOnMac ? "Yes" : "No").\n
        Log (Please do not change):\n\(OSLogString)
        """
    }

    public var body: some View {
        NavigationStack {
            List {
                headerSection
                customTopSection() // Custom section
                applicationInfoSection
                aboutTheDeveloperSection
                customBottomSection()
                footerSection
            }
            .task {
#if canImport(StoreKit)
                if appStoreDeveloperURL != nil &&
                    Int.random(in: 0..<10) == 5 {
                    requestReview()
                }
#endif
            }
            .buttonStyle(.borderless)
            .foregroundStyle(Color.primary)
            .navigationTitle(Text("Settings", bundle: Bundle.module))
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
#if canImport(SwiftUI) && canImport(MessageUI)
            .sheet(isPresented: $isShowingMailView) {
                if let supportEmail = self.supportEmail {
                    MailView(result: $result) { composer in
                        composer.setSubject("\(AppInfo.appName.slugified) Feedback")
                        composer.setToRecipients([supportEmail])
                        composer.setMessageBody(getMailBody, isHTML: false)
                    }
                }
            }
#endif
        }
    }

    var headerSection: some View {
        Section {
            VStack(alignment: .center) {
                AppInfo.appIcon
                    .resizable()
                    .cornerRadius(18)
                    .frame(width: 124, height: 124)

                Text(AppInfo.appName)
                    .font(.title)

                if let createdBy {
                    Text(.init("Created by \(createdBy)"), bundle: Bundle.module)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .listRowSeparator(.hidden)
    }

    var applicationInfoSection: some View {
        Section {
            if let changeLog {
                NavigationLink(
                    destination: SEChangeLogView(changeLog: changeLog)
                ) {
                    Label {
                        Text("Changelog", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "newspaper")
                            .accessibilityHidden(true)
                    }
                }
            }

            if let acknowledgments {
                NavigationLink(
                    destination: SEAcknowledgementView(entries: acknowledgments)
                ) {
                    Label {
                        Text("Acknowledgements", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "paperclip")
                            .accessibilityHidden(true)
                    }
                }
            }

            if let privacyPolicyURL {
                Button {
                    openURL(privacyPolicyURL)
                } label: {
                    Label {
                        Text("Privacy Policy", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "person.badge.key")
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let reviewURL = reviewURL {
                    Button {
                        openURL(reviewURL)
                    } label: {
                        Label {
                            Text("Rate the app", bundle: Bundle.module)
                        } icon: {
                            Image(systemName: "star")
                                .accessibilityHidden(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

            if let supportEmail {
                Button {
                    Task {
#if canImport(OSLogViewer) && canImport(OSLog)
                        if let extractor {
                            isLoading = true
                            OSLogString = await extractor.export()
                            isLoading = false
                        }
#endif
#if canImport(MessageUI)
                        if MFMailComposeViewController.canSendMail() {
                            isShowingMailView.toggle()
                            return
                        }
#endif

                        // Send mail
                        if let body = getMailBody.addingPercentEncoding(
                            withAllowedCharacters: .urlHostAllowed
                        ) {
                            let mail = "mailto:\(supportEmail)" +
                            "?subject=\(AppInfo.appName.slugified)%20Feedback" +
                            "&body=\(body)"
                            if let urlStr = URL(string: mail) {
                                openURL(urlStr)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Label {
                            Text("Feedback", bundle: Bundle.main)
                        } icon: {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                .accessibilityHidden(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if isLoading {
                            Spacer()

                            ProgressView()
                                .controlSize(.small)

                            Text("Fetching logs...", bundle: Bundle.module)
                        }
                    }
                }
                .disabled(isLoading)
            }
        } header: {
            Label {
                Text("Application Info", bundle: Bundle.module)
            } icon: {
                Image(systemName: "info.circle")
                    .accessibilityHidden(true)
            }
        }
        .task {
            if reviewURL == nil {
                reviewURL = await AppInfo.getReviewURL()
            }
        }
    }

    var aboutTheDeveloperSection: some View {
        Section {
            if let twitterHandle,
               let url = URL(string: "https://twitter.com/\(twitterHandle)") {
                Button {
                    openURL(url)
                } label: {
                    Label {
                        Text("𝕏/Twitter", bundle: Bundle.module)
                    } icon: {
                        Image("x-twitter", bundle: Bundle.module)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let blueskyHandle,
               let url = URL(string: "https://bsky.app/profile/\(blueskyHandle)") {
                Button {
                    openURL(url)
                } label: {
                    Label {
                        Text("Bluesky", bundle: Bundle.module)
                    } icon: {
                        Image("bluesky", bundle: Bundle.module)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let mastodonHandle,
               let url = URL(string: "https://mastodon.social/\(mastodonHandle)") {
                Button {
                    openURL(url)
                } label: {
                    Label {
                        Text("Mastodon", bundle: Bundle.module)
                    } icon: {
                        Image("mastodon", bundle: Bundle.module)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let url = developerURL {
                Button {
                    openURL(url)
                } label: {
                    Label {
                        Text("More apps from the developer", bundle: Bundle.module)
                    } icon: {
                        Image(systemName: "info.bubble")
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } header: {
            Label {
                Text("About the developer", bundle: Bundle.module)
            } icon: {
                Image(systemName: "person")
                    .accessibilityHidden(true)
            }
        }
        .task {
            if developerURL == nil {
                developerURL = await AppInfo.getDeveloperURL()
            }
        }
    }

    var footerSection: some View {
        VStack(alignment: .leading) {
            Text(
                "\(AppInfo.appName) version: \(AppInfo.versionNumber), build: \(AppInfo.buildNumber)",
                bundle: Bundle.module
            )
            if let createdBy {
                Text(
                    .init("Created by \(createdBy)"),
                    bundle: Bundle.module
                )
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct SESettingsViewPreview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SESettingsView(
                _changeLog: [
                    .init(version: "0.0.1", text: "Initial version")
                ],
                _acknowledgements: [
                    .init(
                        name: "This Package",
                        copyright: "Wesley de Groot",
                        licence: "Licence",
                        url: "https://wesleydegroot.nl"
                    )
                ]
            )
        }
    }
}

#endif
// swiftlint:disable:this file_length
