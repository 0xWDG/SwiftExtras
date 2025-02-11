//
//  SESettingsView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 09/02/2025.
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
public struct SESettingsView<Content: View>: View {
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
    let customSection: () -> Content?

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
        @ViewBuilder content: @escaping () -> Content? = { nil }
    ) {
        self.createdBy = createdBy
        self.privacyPolicyURL = privacyPolicyURL
        self.supportEmail = supportEmail
        self.twitterHandle = twitterHandle
        self.blueskyHandle = blueskyHandle
        self.mastodonHandle = mastodonHandle
        self.changeLog = changeLog
        self.acknowledgments = acknowledgements
        self.customSection = content
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
        @ViewBuilder content: @escaping () -> Content? = { nil }
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
        self.customSection = content
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
                customSection() // Custom section
                applicationInfoSection
                aboutTheDeveloperSection
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
            .navigationTitle("About")
        }
    }

    var headerSection: some View {
        Section {
            VStack(alignment: .center) {
                AppInfo.appIcon
                    .resizable()
                    .frame(width: 124, height: 124)

                Text(AppInfo.appName)
                    .font(.title)

                if let createdBy {
                    Text(.init("Created by \(createdBy)"))
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
                    Label(
                        "Changelog",
                        systemImage: "newspaper"
                    )
                }
            }

            if let acknowledgments {
                NavigationLink(
                    destination: SEAcknowledgementView(entries: acknowledgments)
                ) {
                    Label(
                        "Acknowledgements",
                        systemImage: "paperclip"
                    )
                }
            }

            if let privacyPolicyURL {
                Button {
                    openURL(privacyPolicyURL)
                } label: {
                    Label(
                        "Privacy Policy",
                        systemImage: "person.badge.key"
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let reviewURL = reviewURL {
                    Button {
                        openURL(reviewURL)
                    } label: {
                        Label(
                            "Rate the app",
                            systemImage: "star"
                        )
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
                        Label(
                            "Feedback",
                            systemImage: "pencil.and.ellipsis.rectangle"
                        ).frame(maxWidth: .infinity, alignment: .leading)

                        if isLoading {
                            Spacer()

                            ProgressView()
                                .controlSize(.small)
                            Text("Fetching logs...")
                        }
                    }
                }
                .disabled(isLoading)
            }
        } header: {
            Label("Application Info", systemImage: "info.circle")
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
                        Text("𝕏/Twitter")
                    } icon: {
                        Image("x-twitter", bundle: Bundle.module)
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
                        Text("Bluesky")
                    } icon: {
                        Image("bluesky", bundle: Bundle.module)
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
                        Text("Mastodon")
                    } icon: {
                        Image("mastodon", bundle: Bundle.module)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            if let url = developerURL {
                Button {
                    openURL(url)
                } label: {
                    Label("More apps from the developer", systemImage: "info.bubble")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } header: {
            Label("About the developer", systemImage: "person")
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
                "\(AppInfo.appName) version: \(AppInfo.versionNumber), build: \(AppInfo.buildNumber)"
            )
            if let createdBy {
                Text(.init("Created by \(createdBy)"))
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#endif
