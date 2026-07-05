//
//  Toast.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

struct ToastPresenter: ViewModifier {
    @Binding var isPresented: Bool

    let duration: TimeInterval
    let systemImageName: String?
    let message: String
    let tint: Color?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    HStack {
                        if let systemImageName {
                            Image(systemName: systemImageName)
                                .foregroundStyle(foregroundStyle)
                                .accessibilityHidden(true)
                        }

                        Text(message)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(foregroundStyle)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical)
                    .toastBackground(tint)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(message)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.default, value: isPresented)
            .task(id: isPresented) {
                guard isPresented else { return }
                try? await Task.sleep(for: .seconds(duration))
                isPresented = false
            }
    }

    private var foregroundStyle: Color {
        tint == nil ? .primary : .white
    }
}

private extension View {
    @ViewBuilder
    func toastBackground(_ tint: Color?) -> some View {
#if compiler(>=6.2)
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, *) {
            self.glassEffect(.regular.tint(tint))
        } else {
            toastFallbackBackground(tint)
        }
#else
        toastFallbackBackground(tint)
#endif
    }

    @ViewBuilder
    private func toastFallbackBackground(_ tint: Color?) -> some View {
        background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint ?? Color.secondarySystemBackground)
                .shadow(color: .black.opacity(0.16), radius: 12, y: 4)
        )
    }
}

extension View {
    /// Adds a toast message to the view
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation of the toast
    ///   - duration: Duration in seconds for how long the toast should be visible (default 3 seconds)
    ///   - systemImageName: Optional SF Symbol name to display alongside the message
    ///   - message: The message to display in the toast
    ///   - tint: Optional color to tint the toast background (default nil)
    public func toast(
        isPresented: Binding<Bool>,
        duration: TimeInterval = 3.0,
        systemImageName: String? = nil,
        message: String,
        tint: Color? = nil
    ) -> some View {
        modifier(
            ToastPresenter(
                isPresented: isPresented,
                duration: duration,
                systemImageName: systemImageName,
                message: message,
                tint: tint
            )
        )
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        Text("Hello World!")
    }
    .toast(
        isPresented: .constant(true),
        systemImageName: "star",
        message: "This is a toast message"
    )
}
#endif
#endif
