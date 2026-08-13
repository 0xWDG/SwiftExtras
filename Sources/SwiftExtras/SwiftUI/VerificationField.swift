//
//  VerificationField.swift
//  SwiftExtras
//
//  Created by Balaji Venkatesh on 2025-01-30.
//  https://github.com/0xWDG/SwiftExtras
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && os(iOS)
import SwiftUI

/// The supported number of digits in a verification code.
public enum CodeType: Int, CaseIterable, Sendable {
    /// A four-digit code.
    case four = 4
    /// A six-digit code.
    case six = 6

    /// A readable description of the code length.
    public var stringValue: String {
        "\(rawValue)-digit"
    }
}

/// The validation state of a verification field.
public enum TypingState: Sendable {
    /// The code is incomplete or is being checked.
    case typing
    /// The code is valid.
    case valid
    /// The code is invalid.
    case invalid
}

/// The visual style of a verification field.
public enum VerificationFieldStyle: String, CaseIterable, Sendable {
    /// Draws a rounded border around each digit.
    case roundedBorder = "Rounded Border"
    /// Draws a line below each digit.
    case underlined = "Underlined"
}

/// A one-time-code field that displays one visual slot per digit.
@available(iOS 17, *)
public struct VerificationField: View {
    private let type: CodeType
    private let style: VerificationFieldStyle
    @Binding private var value: String
    private let onChange: (String) async -> TypingState

    @State private var state = TypingState.typing
    @State private var invalidTrigger = false
    @State private var attachmentAnchor = UnitPoint.center
    @State private var showsPastePopover = false
    @FocusState private var isActive: Bool

    /// Creates a verification-code field.
    ///
    /// - Parameters:
    ///   - type: The number of digits accepted by the field.
    ///   - style: The visual style of each digit slot.
    ///   - value: The verification-code value.
    ///   - onChange: An asynchronous operation that validates the current value.
    public init(
        type: CodeType,
        style: VerificationFieldStyle = .roundedBorder,
        value: Binding<String>,
        onChange: @escaping (String) async -> TypingState
    ) {
        self.type = type
        self.style = style
        self._value = value
        self.onChange = onChange
    }

    /// The verification-code input and its individual digit slots.
    public var body: some View {
        Button {
            isActive = true
        } label: {
            HStack(spacing: slotSpacing) {
                ForEach(0..<type.rawValue, id: \.self) { index in
                    characterView(at: index)
                        .overlay {
                            pasteGesture(at: index)
                        }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Verification code")
        .accessibilityValue(accessibilityValue)
        .accessibilityHint("Double-tap to enter the \(type.rawValue)-digit code")
        .animation(.easeInOut(duration: 0.2), value: value)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        .phaseAnimator(
            [0, 10, -10, 10, -5, 5, 0],
            trigger: invalidTrigger
        ) { content, offset in
            content.offset(x: offset)
        } animation: { _ in
            .linear(duration: 0.06)
        }
        .background(hiddenTextField)
        .popover(
            isPresented: $showsPastePopover,
            attachmentAnchor: .point(attachmentAnchor),
            arrowEdge: .bottom
        ) {
            pastePopover
        }
        .onChange(of: value) { _, newValue in
            let sanitizedValue = sanitized(newValue)
            if sanitizedValue != newValue {
                value = sanitizedValue
            }
        }
        .task(id: value) {
            let newState = await onChange(value)
            guard !Task.isCancelled else { return }
            state = newState
            if newState == .invalid {
                invalidTrigger.toggle()
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isActive = false
                }
                .tint(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityHint("Dismisses the number keyboard")
            }
        }
        .coordinateSpace(.named(Self.coordinateSpaceName))
    }

    private var hiddenTextField: some View {
        TextField("Verification code", text: $value)
            .focused($isActive)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .mask(alignment: .trailing) {
                Rectangle()
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private var pastePopover: some View {
        PasteButton(payloadType: String.self) { strings in
            if let firstText = strings.first {
                let pastedValue = sanitized(firstText)
                if pastedValue.count == type.rawValue {
                    value = pastedValue
                }
            }
            showsPastePopover = false
        }
        .labelStyle(.titleOnly)
        .tint(.primary)
        .accessibilityLabel("Paste verification code")
        .accessibilityHint("Pastes a \(type.rawValue)-digit code from the clipboard")
        .padding(5)
        .presentationBackground(.ultraThinMaterial)
        .presentationCompactAdaptation(.popover)
    }

    private var slotSpacing: CGFloat {
        style == .roundedBorder ? 6 : 10
    }

    private var accessibilityValue: String {
        switch state {
        case .typing:
            return "\(value.count) of \(type.rawValue) digits entered"
        case .valid:
            return "Valid code"
        case .invalid:
            return "Invalid code"
        }
    }

    private func characterView(at index: Int) -> some View {
        Group {
            switch style {
            case .roundedBorder:
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(at: index), lineWidth: 1.2)
            case .underlined:
                Rectangle()
                    .fill(borderColor(at: index))
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(width: style == .roundedBorder ? 50 : 40, height: 50)
        .overlay {
            let character = character(at: index)
            if !character.isEmpty {
                Text(character)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.blurReplace)
            }
        }
        .accessibilityHidden(true)
    }

    private func pasteGesture(at index: Int) -> some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: .named(Self.coordinateSpaceName))
            Color.clear
                .contentShape(Rectangle())
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.2)
                        .onEnded { _ in
                            let totalWidth = frame.width * CGFloat(type.rawValue)
                            let totalSpacing = CGFloat(type.rawValue - 1) * slotSpacing
                            let maximumWidth = totalWidth + totalSpacing
                            attachmentAnchor = UnitPoint(
                                x: maximumWidth > 0 ? frame.midX / maximumWidth : 0.5,
                                y: 0
                            )
                            showsPastePopover = true
                        }
                )
        }
    }

    private func character(at index: Int) -> String {
        guard value.count > index else { return "" }
        return String(value[value.index(value.startIndex, offsetBy: index)])
    }

    private func borderColor(at index: Int) -> Color {
        switch state {
        case .typing:
            return value.count == index && isActive ? .primary : .gray
        case .valid:
            return .green
        case .invalid:
            return .red
        }
    }

    private func sanitized(_ input: String) -> String {
        String(input.filter(\.isNumber).prefix(type.rawValue))
    }

    private static var coordinateSpaceName: String { "SwiftExtras.VerificationField" }
}

#if DEBUG
@available(iOS 17, *)
private struct VerificationFieldPreview: View {
    @State private var code = "12"

    var body: some View {
        VerificationField(type: .six, value: $code) { value in
            value.count == 6 ? .valid : .typing
        }
        .padding()
    }
}

@available(iOS 17, *)
#Preview {
    VerificationFieldPreview()
}
#endif
#endif
