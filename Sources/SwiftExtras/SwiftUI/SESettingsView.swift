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
import StoreKit

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
    //    @Environment(\.requestReview) var requestReview

#if canImport(MessageUI)
    @State
    private var result: Result<MFMailComposeResult, Error>?
#endif

    @State
    private var isShowingMailView = false

#if canImport(OSLog)
    var extractor: OSLogExtractor?
#endif

    @State
    var OSLogString = ""

    @State
    private var isLoading: Bool = false

    // When adding a new `@State` this view crashes.

    // MARK: Custom
    var createdBy: String?
    var privacyPolicyURL: URL?
    var supportEmail: String? = "email@wesleydegroot.nl"
    var twitterHandle: String? = "0xWDG"
    var blueskyHandle: String? = "0xwdg.bsky.social"
    var mastodonHandle: String? = "@0xWDG@mastodon.social"
    var appStoreDeveloperURL: String? = "https://apps.apple.com/developer/wesley-de-groot/id602359900"
    var changeLog: [SEChangeLogEntry]?
    let content: () -> Content?

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
    ///   - appStoreDeveloperURL: Your App Developer URL
    ///   - OSLogSubsystem: The subsystem for your OS-Logs (nil = hidden), no value = AppBundle
    ///   - changeLog: Changelog
    ///   - content: Additional content
    public init(
        createdBy: String? = nil,
        privacyPolicyURL: URL? = nil,
        supportEmail: String? = nil,
        twitterHandle: String? = nil,
        blueskyHandle: String? = nil,
        mastodonHandle: String? = nil,
        appStoreDeveloperURL: String? = nil,
        OSLogSubsystem: String? = AppInfo.bundleIdentifier,
        changeLog: [SEChangeLogEntry]?,
        @ViewBuilder content: @escaping () -> Content? = { nil }
    ) {
        self.createdBy = createdBy
        self.privacyPolicyURL = privacyPolicyURL
        self.supportEmail = supportEmail
        self.twitterHandle = twitterHandle
        self.blueskyHandle = blueskyHandle
        self.mastodonHandle = mastodonHandle
        self.appStoreDeveloperURL = appStoreDeveloperURL
        self.changeLog = changeLog
        self.content = content
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
        appStoreAppURL: URL? = nil,
        _changeLog: [SEChangeLogEntry]?,
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
        self.appStoreDeveloperURL = "https://apps.apple.com/developer/wesley-de-groot/id602359900"
        self.changeLog = _changeLog
        self.content = content
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
                content() // Custom settings
                applicationInfoSection
                aboutTheDeveloperSection
                footerSection
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

            AsyncView {
                return await AppInfo.getReviewURL()
            } content: { response in
                if let reviewURL = response {
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

            AsyncView {
                return await AppInfo.getDeveloperURL()
            } content: { result in
                if let url = result {
                    Button {
                        openURL(url)
                    } label: {
                        Label("More apps from the developer", systemImage: "info.bubble")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        } header: {
            Label("About the developer", systemImage: "person")
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

/// SwiftExtras Change Log Entry
public struct SEChangeLogEntry: Identifiable {
    /// The unique identifier for this entry.
    public var id: UUID = UUID()

    /// The version number for this entry.
    public var version: String

    /// The changelog for this entry.
    public var text: String

    /// Initialize a new change log entry.
    ///
    /// - Parameters:
    ///   - version: The version number for this entry.
    ///   - text: The changelog for this entry.
    public init(version: String, text: String) {
        self.version = version
        self.text = text
    }
}

/// SwiftExtras Change Log View
///
/// SwiftExtras Change Log View is a SwiftUI View that can be used to show a change log.
public struct SEChangeLogView: View {
    /// The change log entries to display.
    public var changeLog: [SEChangeLogEntry]

    public var body: some View {
        List {
            ForEach(changeLog) { changeLogEntry in
                Section(.init("**Version \(changeLogEntry.version)**")) {
                    Text(.init(changeLogEntry.text))
                }
            }
        }
        .navigationTitle("Changelog")
    }

    /// Initialize a new change log view.
    ///
    /// - Parameters:
    ///   - changeLog: The change log entries to display.
    public init(changeLog: [SEChangeLogEntry]) {
        self.changeLog = changeLog
    }
}

#endif
