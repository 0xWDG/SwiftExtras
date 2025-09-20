//
//  NotificationView.swift
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

/// Notification View
/// 
/// A simple notification view that can be used to display notifications in your app.
/// It supports a title, message, and an optional onClick action.
/// The notification will animate in and out, and will automatically disappear after a few seconds if not clicked.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct NotificationView: View {
    var title: LocalizedStringKey
    var message: LocalizedStringKey
    var onClick: (() -> Void)?

    @State private var animateNotification: Bool = false

    /// Notification View
    /// 
    /// A simple notification view that can be used to display notifications in your app.
    /// The notification will animate in and out, and will automatically disappear after a few seconds if not clicked.
    /// 
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - message: The message of the notification.
    ///   - onClick: An optional action to perform when the notification is clicked.
    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        onClick: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.onClick = onClick
    }

    /// The body of the notification view.
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            AppInfo.appIcon
                .font(.title2)
                .foregroundStyle(.background)
                .frame(width: 40, height: 40)
                .background(.primary)
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.medium)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Text("Now", bundle: Bundle.module)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                }

                Text(message)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(.background)
        .clipShape(.rect(cornerRadius: 20))
        .clipped()
        .shadow(color: .gray.opacity(0.5), radius: 1.5)
        .padding(.horizontal, 12)
        .offset(y: animateNotification ? 0 : -200)
        .task {
            await loopAnimation()
        }
        .onTapGesture {
            withAnimation(.smooth(duration: 1)) {
                animateNotification = false
            }

            onClick?()
        }
        .accessibilityAddTraits(.isButton)
    }

    private func loopAnimation() async {
        try? await Task.sleep(for: .seconds(0.5))

        withAnimation(.smooth(duration: 1)) {
            animateNotification = true
        }

        if onClick == nil {
            try? await Task.sleep(for: .seconds(4))

            withAnimation(.smooth(duration: 1)) {
                animateNotification = false
            }

            try? await Task.sleep(for: .seconds(1.3))
            await loopAnimation()
        }
    }
}

extension View {
    /// Notification View
    /// 
    /// A simple notification view that can be used to display notifications in your app.
    /// The notification will animate in and out, and will automatically disappear after a few seconds if not clicked.
    /// 
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - message: The message of the notification.
    ///   - onClick: An action to perform when the notification is clicked.
    @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
    public func notification(
        title: LocalizedStringKey,
        message: LocalizedStringKey,
        onClick: @escaping () -> Void
    ) -> some View {
        ZStack {
            VStack {
                NotificationView(title: title, message: message, onClick: onClick)
                .frame(maxWidth: .infinity)
                Spacer()
            }

            self
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    ZStack {
        VStack {
            NotificationView(
                title: "Hi",
                message: "Hello"
            )
            .frame(maxWidth: .infinity)
            Spacer()
        }

        Text("Hello World")
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("View Extension") {
    Text("Hello World")
        .notification(title: "Test", message: ":)", onClick: {
            print("OK")
        })
}
#endif
#endif
