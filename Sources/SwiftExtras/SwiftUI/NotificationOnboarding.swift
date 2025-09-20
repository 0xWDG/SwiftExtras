//
//  NotificationOnboarding.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//
//  Modified version of https://www.youtube.com/watch?v=Cbgvi4G_LIs

#if canImport(SwiftUI) && canImport(UserNotifications)
import SwiftUI
import UserNotifications

/// A SwiftUI view that presents an onboarding screen to request push notification permissions from the user.
/// The view includes a mock iPhone interface with a sample notification and buttons to either request permission
/// or dismiss the onboarding. It also handles the permission request process and updates the UI based on
/// the user's response.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct NotificationOnboarding: View {
    var title: LocalizedStringKey
    var content: LocalizedStringKey
    var notificationTitle: LocalizedStringKey
    var notificationContent: LocalizedStringKey
    var primaryButtonTitle: LocalizedStringKey
    var secondaryButtonTitle: LocalizedStringKey
    var onPermissionChange: (_ isApproved: Bool) -> Void
    /// View Properties
    @State private var askPermission: Bool = false
    @State private var showArrow: Bool = false
    @State private var authorization: UNAuthorizationStatus = .notDetermined
    @State private var arrowY: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss

    /// A SwiftUI view that presents an onboarding screen to request push notification permissions from the user.
    /// The view includes a mock iPhone interface with a sample notification and buttons to either request permission
    /// or dismiss the onboarding. It also handles the permission request process and updates the UI based on
    /// the user's response.
    /// 
    /// - Parameters:
    ///   - title: The title text displayed at the top of the onboarding screen.
    ///   - content: The content text displayed below the title.
    ///   - notificationTitle: The title of the mock notification displayed in the iPhone preview.
    ///   - notificationContent: The content of the mock notification.
    ///   - primaryButtonTitle: The title of the primary action button.
    ///   - secondaryButtonTitle: The title of the secondary action button.
    ///   - onPermissionChange: A closure that is called when the notification permission status changes.
    public init(
        title: LocalizedStringKey = "Stay connected with\npush notifications",
        content: LocalizedStringKey = "We will send you push notifications to keep you updated on the latest news and updates.",
        // swiftlint:disable:previous line_length
        notificationTitle: LocalizedStringKey = "You've got a message",
        notificationContent: LocalizedStringKey = "Welcome to \(AppInfo.appName)!",
        primaryButtonTitle: LocalizedStringKey = "Continue",
        secondaryButtonTitle: LocalizedStringKey = "Ask me later",
        onPermissionChange: @escaping (_ isApproved: Bool) -> Void = { _ in }
    ) {
        self.title = title
        self.content = content
        self.notificationTitle = notificationTitle
        self.notificationContent = notificationContent
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.onPermissionChange = onPermissionChange
    }

    private var isIOS26: Bool {
        if #available(iOS 26, *) {
            return true
        }

        return false
    }

    public var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(.background)
                    .ignoresSafeArea()

                /// Allow Button Pointing Arrow
                Image(systemName: "arrow.up")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(Color.primary)
                    .offset(x: isIOS26 ? 75 : 70, y: 155 + arrowY)
                    .accessibilityHidden(true)
            }
            .compositingGroup()
            .opacity(askPermission ? 1 : 0)
            .blur(radius: askPermission ? 0 : 10)
            .allowsHitTesting(false)

            /// Animated Mobile Like Notification UI
            VStack(spacing: 0) {
                iPhonePreview()
                    .padding(.top, 15)

                VStack(spacing: 20) {
                    Text(title)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(content)
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)

                    /// Primary & Secondary Button's
                    Button {
                        if authorization == .authorized {
                            dismiss()
                        } else if authorization == .denied {
                            /// Visit Settings
                            AppInfo.openNotificationSettings()
                        } else {
                            askNotificationPermission()
                        }
                    } label: {
                        Text(
                            authorization == .denied ? "Go to Settings" : primaryButtonTitle
                        )
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .geometryGroup()

                    if authorization == .notDetermined {
                        Button {
                            dismiss()
                        } label: {
                            Text(secondaryButtonTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
            .compositingGroup()
            .opacity(askPermission ? 0 : 1)
        }
        /// To Cut off the infinite loop!
        .task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            let authorization = settings.authorizationStatus
            self.authorization = authorization

            if authorization == .authorized {
                onPermissionChange(true)
                dismiss()
            }

            if authorization == .denied {
                onPermissionChange(false)
            }
        }
        .interactiveDismissDisabled()
    }

    @ViewBuilder
    private func iPhonePreview() -> some View {
        // swiftlint:disable:previous function_body_length
        GeometryReader {
            let size = $0.size
            let scale = min(size.height / 340, 1)
            let width: CGFloat = 320
            let cornerRadius: CGFloat = 30

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.primary.opacity(0.06))

                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray.opacity(0.5), lineWidth: 1.5)

                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        RoundedRectangle(cornerRadius: 20)
                        RoundedRectangle(cornerRadius: 20)
                    }
                    .frame(height: 130)

                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 4), spacing: 15) {
                        ForEach(1...12, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 55)
                        }
                    }
                }
                .padding(20)
                .padding(.top, 20)
                .foregroundStyle(Color.primary.opacity(0.2))

                HStack(spacing: 4) {
                    Text("9:41")
                        .fontWeight(.bold)
                        .accessibilityHidden(true)
                    Spacer()
                    Image(systemName: "cellularbars")
                        .accessibilityHidden(true)
                    Image(systemName: "wifi")
                        .accessibilityHidden(true)
                    Image(systemName: "battery.50percent")
                        .accessibilityHidden(true)
                }
                .font(.caption2)
                .padding(.horizontal, 20)
                .padding(.top, 15)

                NotificationView(
                    title: notificationTitle,
                    message: notificationContent
                )
                .padding(.top, 40)
            }
            .frame(width: width)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .mask {
                LinearGradient(stops: [
                    .init(color: .white, location: 0),
                    .init(color: .clear, location: 0.9)
                ], startPoint: .top, endPoint: .bottom)
                .padding(-1)
            }
            .scaleEffect(scale, anchor: .top)
        }
    }

    private func pulseArrow() async {
        withAnimation(.spring(duration: 1).repeatForever()) {
            arrowY = Bool.random() ? 0 : 2
        }
        try? await Task.sleep(for: .milliseconds(500))
        await pulseArrow()
    }

    private func askNotificationPermission() {
        Task { @MainActor in
            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                askPermission = true
            }

            try? await Task.sleep(for: .seconds(0.3))

            withAnimation(.linear(duration: 0.3)) {
                showArrow = true
                Task { await pulseArrow() }
            }

#if !targetEnvironment(simulator)
            let status = (
                try? await UNUserNotificationCenter
                    .current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
            ) ?? false

            let authorization = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
            onPermissionChange(status)
#else
            try? await Task.sleep(for: .seconds(15))
#endif

            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                askPermission = false
                showArrow = false
                self.authorization = authorization
                dismiss()
            }
        }
    }
}

extension View {
    /// A SwiftUI view that presents an onboarding screen to request push notification permissions from the user.
    /// The view includes a mock iPhone interface with a sample notification and buttons to either request permission
    /// or dismiss the onboarding. It also handles the permission request process and updates the UI based on
    /// the user's response.
    /// 
    /// - Parameters:
    ///   - title: The title text displayed at the top of the onboarding screen.
    ///   - content: The content text displayed below the title.
    ///   - notificationTitle: The title of the mock notification displayed in the iPhone preview.
    ///   - notificationContent: The content of the mock notification.
    ///   - primaryButtonTitle: The title of the primary action button.
    ///   - secondaryButtonTitle: The title of the secondary action button.
    ///   - onPermissionChange: A closure that is called when the notification permission status changes.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    public func notificationOnboarding(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey = "Stay connected with\npush notifications",
        content: LocalizedStringKey = "We will send you push notifications to keep you updated on the latest news and updates.",
        // swiftlint:disable:previous line_length
        notificationTitle: LocalizedStringKey = "You've got a message",
        notificationContent: LocalizedStringKey = "Welcome to \(AppInfo.appName)!",
        primaryButtonTitle: LocalizedStringKey = "Continue",
        secondaryButtonTitle: LocalizedStringKey = "Ask me later",
        onPermissionChange: @escaping (_ isApproved: Bool) -> Void = { _ in }
    ) -> some View {
        #if !os(macOS)
        self
            .fullScreenCover(isPresented: isPresented) {
                NotificationOnboarding {
                    onPermissionChange($0)
                }
            }
        #else
        self
            .overlay {
                if isPresented.wrappedValue {
                    NotificationOnboarding {
                        onPermissionChange($0)
                    }
                }
            }
        #endif
    }
}
#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var isPresented: Bool = true
    VStack {
        Button("Toggle") {
            isPresented.toggle()
        }
        .notificationOnboarding(isPresented: $isPresented) {
            print("Permission changed: \($0)")
        }
    }
}
#endif
#endif
