//
//  DisclosureSection.swift
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

/// Make your sections colapsable like `DisclosureGroup`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DisclosureSection<Content: View, Label: View>: View {
    @State private var isExpanded: Bool = false

    private var angle: Double {
        isExpanded ? 90 : 0
    }

    private let content: () -> Content
    private let label: () -> Label

    /// Initializes a `DisclosureSection` with a localized title and content.
    ///
    /// - Parameters:
    ///   - titleKey: The localized key for the section title.
    ///   - isExpanded: Is the section expanded
    ///   - content: A closure that returns the content to be displayed when the section is expanded.
    ///
    /// **Example:**
    /// ```swift
    /// DisclosureSection("Account Settings") {
    ///     // Content to be displayed when the section is expanded
    /// }
    /// ```
    public init(
        _ titleKey: LocalizedStringKey,
        isExpanded: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == Text {
        self.content = content
        self.isExpanded = isExpanded
        self.label = { Text(titleKey) }
    }

    /// Initializes a `DisclosureSection` with a localized title and content.
    ///
    /// - Parameters:
    ///   - titleKey: The localized key for the section title.
    ///   - isExpanded: Is the section expanded
    ///   - content: A closure that returns the content to be displayed when the section is expanded.
    ///
    /// **Example:**
    /// ```swift
    /// DisclosureSection("Account Settings") {
    ///     // Content to be displayed when the section is expanded
    /// }
    /// ```
    public init<S>(
        _ titleKey: S,
        isExpanded: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) where S: StringProtocol, Label == Text {
        self.content = content
        self.isExpanded = isExpanded
        self.label = { Text(titleKey) }
    }

    /// Initializes a `DisclosureSection` with custom label, content, and footer.
    ///
    /// - Parameters:
    ///   - content: A closure that returns the content to be displayed when the section is expanded.
    ///   - isExpanded: Is the section expanded
    ///   - label: A closure that returns the custom label view.
    ///
    /// **Example:**
    /// ```swift
    /// DisclosureSection {
    ///     // Content to be displayed when the section is expanded
    /// } label: {
    ///     HStack {
    ///         Image(systemName: "gear")
    ///         Text("Settings")
    ///     }
    /// }
    /// ```
    public init(
        @ViewBuilder content: @escaping () -> Content,
        isExpanded: Bool = false,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.content = content
        self.isExpanded = isExpanded
        self.label = label
    }

    public var body: some View {
        if #available(iOS 17.0, macOS 14.0, visionOS 1.0, tvOS 17.0, watchOS 10, *) {
            Section(isExpanded: $isExpanded) {
                self.content()
            } header: {
                    Button {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    } label: {
                        HStack {
                            label()
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .frame(width: 6)
                                .font(.footnote.weight(.bold))
                                .foregroundStyle(Color.accentColor)
                                .animation(.smooth, value: self.isExpanded)
                                .rotationEffect(Angle(degrees: angle))
                                .accessibilityLabel(self.isExpanded ? "Collapse" : "Expand")
                        }
                    }
                    .buttonStyle(.list)
            }
        } else {
            Section(content: self.content, header: self.label)
        }
    }
}

#if DEBUG
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
#Preview {
    Form {
        DisclosureSection("Custom Disclosure Section") {
            Text("Test")
            Text("Test")
        }

        DisclosureSection("Custom Disclosure Section", isExpanded: true) {
            Text("Test")
            Text("Test")
        }
    }
    .formStyle(.grouped)
}
#endif
#endif
