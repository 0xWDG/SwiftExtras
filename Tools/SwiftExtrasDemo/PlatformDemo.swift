//
//  PlatformDemo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftExtras
import SwiftUI
#if os(iOS)
import MessageUI
#endif

@available(macOS 14, *)
struct PlatformDemo: View {
    var body: some View {
        DemoPage(
            "Platform APIs",
            summary: "Application metadata, web content, social symbols, settings, permissions, and iOS integrations."
        ) {
            AppInfoDemo()
            WebContentDemo()
            SocialIconsDemo()
            SystemPresentationDemo()
#if os(iOS)
            KeyboardDismissDemo()
#endif
            PlatformAvailabilityDemo()
        }
    }
}

@available(macOS 14, *)
struct AppInfoDemo: View {
    var body: some View {
        DemoPanel("AppInfo, Device, and DeviceInfo", systemImage: "info.circle") {
            HStack(spacing: 16) {
                AppInfo.appIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .accessibilityLabel("Application icon")
                VStack(alignment: .leading) {
                    Text(AppInfo.appName)
                        .font(.title2.bold())
                    Text(AppInfo.bundleIdentifier)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
            }

            DemoValueRow(label: "Version / build", value: "\(AppInfo.versionNumber) (\(AppInfo.buildNumber))")
            DemoValueRow(label: "Platform", value: AppInfo.platform)
            DemoValueRow(label: "Operating system", value: AppInfo.operatingSystem)
            DemoValueRow(label: "Architecture", value: AppInfo.architecture)
            DemoValueRow(label: "Model", value: AppInfo.modelName)
            DemoValueRow(label: "System version", value: AppInfo.systemVersion)
            DemoValueRow(label: "Target environment", value: AppInfo.targetEnvironment)
            DemoValueRow(label: "Debug build", value: AppInfo.isDebugBuild.description)
            DemoValueRow(label: "Debugger attached", value: AppInfo.isDebuggerAttached.description)
            DemoValueRow(label: "Device model", value: Device.model)
            DemoValueRow(label: "Device size", value: Device.size.debugDescription)
            DemoValueRow(label: "DeviceInfo OS", value: "\(DeviceInfo.osName) \(DeviceInfo.systemVersionString)")
            DemoValueRow(label: "Sandboxed", value: DeviceInfo.appIsSandboxed.description)
        }
    }
}

@available(macOS 14, *)
struct WebContentDemo: View {
    private let localPage = URL(
        string: "data:text/html,"
            + "%3Cstyle%3Ebody%7Bfont-family:-apple-system;padding:24px%7D%3C/style%3E"
            + "%3Ch1%3ESwiftExtras%3C/h1%3E"
            + "%3Cp%3EThis%20local%20page%20is%20rendered%20by%20WebView.%3C/p%3E"
    )

    var body: some View {
        DemoPanel("WebView", systemImage: "globe") {
            if let localPage {
                WebView(url: localPage)
                    .frame(height: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityLabel("Local SwiftExtras web page")
            }
        }
    }
}

@available(macOS 14, *)
struct SocialIconsDemo: View {
    private let identifiers = SocialIcons.dict.keys.sorted()

    var body: some View {
        DemoPanel("SocialIcons", systemImage: "person.3.fill") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                ForEach(identifiers, id: \.self) { identifier in
                    Label {
                        Text(identifier)
                    } icon: {
                        SocialIcons.dict[identifier]
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

@available(macOS 14, *)
struct SystemPresentationDemo: View {
    @State private var showsSettings = false
    @State private var showsNotificationOnboarding = false
#if os(iOS)
    @State private var mailResult: Result<MFMailComposeResult, Error>?
    @State private var safariURL = URL(string: "https://github.com/0xWDG/SwiftExtras")
        ?? URL(fileURLWithPath: "/")
    @State private var showsMail = false
    @State private var showsSafari = false
#endif

    var body: some View {
        DemoPanel("Settings and notification onboarding", systemImage: "gearshape.2") {
            Button("Open SESettingsView") {
                showsSettings = true
            }

            Button("Open notification onboarding") {
                showsNotificationOnboarding = true
            }

#if os(iOS)
            Button("Open SwiftExtras in Safari") {
                showsSafari = true
            }

            Button("Open application settings") {
                AppInfo.openSettings()
            }

            Button("Play success feedback") {
                SensoryFeedback(type: .success)
            }

            Button("Compose support email") {
                showsMail = true
            }
            .disabled(MFMailComposeViewController.canSendMail() == false)
            .accessibilityHint(
                MFMailComposeViewController.canSendMail()
                    ? "Opens the system mail composer"
                    : "Mail is not configured on this device"
            )
#endif
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $showsSettings) {
            SESettingsView<EmptyView, EmptyView>(
                createdBy: "SwiftExtras contributors",
                privacyPolicyURL: URL(string: "https://github.com/0xWDG/SwiftExtras"),
                supportEmail: nil,
                OSLogSubsystem: nil,
                changeLog: [SEChangeLogEntry(version: "Demo", text: "Complete component catalog")],
                acknowledgements: [
                    SEAcknowledgement(name: "SwiftExtras", copyright: "0xWDG", licence: "MIT")
                ]
            )
#if os(macOS)
            .frame(minWidth: 620, minHeight: 600)
#endif
        }
        .sheet(isPresented: $showsNotificationOnboarding) {
            NotificationOnboarding()
#if os(macOS)
                .frame(minWidth: 520, minHeight: 680)
#endif
        }
#if os(iOS)
        .sheet(isPresented: $showsSafari) {
            SafariView(url: $safariURL)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showsMail) {
            MailView(result: $mailResult) { composer in
                composer.setSubject("SwiftExtras demo feedback")
                composer.setToRecipients(["support@example.com"])
            }
        }
#endif
    }
}

#if os(iOS)
@available(iOS 17, *)
struct KeyboardDismissDemo: View {
    @State private var text = "Tap outside this field"

    var body: some View {
        DemoPanel("Keyboard dismissal", systemImage: "keyboard.chevron.compact.down") {
            TextField("Editable text", text: $text)
                .textFieldStyle(.roundedBorder)
                .accessibilityHint("Enter text, then tap the panel to dismiss the keyboard")

            Text("Tap this area after editing to dismiss the keyboard.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        }
        .dismissKeyboardOnTap()
    }
}
#endif

@available(macOS 14, *)
struct PlatformAvailabilityDemo: View {
    var body: some View {
        DemoPanel("Platform-specific APIs", systemImage: "iphone.and.arrow.forward") {
            AvailabilityLine(
                name: "Picture in Picture",
                available: PictureInPicture.isSupported,
                platform: "iOS and macOS"
            )
            AvailabilityLine(name: "Background removal", available: true, platform: "iOS 17 and macOS 14")
            AvailabilityLine(name: "SafariView", available: supportsIOS, platform: "iOS")
            AvailabilityLine(name: "MailView", available: canSendMail, platform: "iOS with MessageUI")
            AvailabilityLine(name: "VerificationField", available: supportsIOS, platform: "iOS")
            AvailabilityLine(name: "Keyboard dismissal", available: supportsIOS, platform: "iOS")
            AvailabilityLine(name: "SensoryFeedback", available: supportsIOS, platform: "iOS")
            AvailabilityLine(name: "App settings URLs", available: supportsIOS, platform: "iOS")
            AvailabilityLine(name: "UbiquitousStorage", available: true, platform: "iCloud-enabled apps")
            AvailabilityLine(name: "Screenshot testing", available: true, platform: "XCTest host")
        }
    }

    private var supportsIOS: Bool {
#if os(iOS)
        true
#else
        false
#endif
    }

    private var canSendMail: Bool {
#if os(iOS)
        MFMailComposeViewController.canSendMail()
#else
        false
#endif
    }
}

@available(macOS 14, *)
struct AvailabilityLine: View {
    let name: LocalizedStringResource
    let available: Bool
    let platform: LocalizedStringResource

    var body: some View {
        HStack {
            Label {
                Text(name)
            } icon: {
                Image(systemName: available ? "checkmark.circle.fill" : "info.circle")
            }
                .foregroundStyle(available ? .green : .secondary)
            Spacer()
            Text(platform)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

@available(macOS 14, *)
#Preview("Platform APIs") {
    PlatformDemo()
        .frame(width: 900, height: 700)
}
