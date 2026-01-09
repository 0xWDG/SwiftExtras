//
//  MultiSelectPickerView.swift
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

/// MultiSelectView
///
/// This is a picker view that allows you to select multiple items from a list.
/// It displays a list of items, each with a checkbox that allows you to select or deselect it.
public struct MultiSelectView<Label: View>: View {
    /// The list of all items to read from
    @State var sourceItems: [String]

    /// The values we want to track
    @Binding var selectedItems: [String]

    /// The label for each item
    var label: (_ item: String) -> Label?

    /// MultiSelectPickerView
    ///
    /// This is a picker view that allows you to select multiple items from a list.
    /// It displays a list of items, each with a checkbox that allows you to select or deselect it.
    ///
    /// Usage:
    /// ```
    /// NavigationLink {
    ///     MultiSelectView(
    ///         sourceItems: items,
    ///         selectedItems: $selectedItems
    ///     ) { item in
    ///         Label(item, systemImage: item)
    ///     }
    /// } label: {
    ///     Text("Picker + Label")
    /// }
    /// ```
    ///
    /// The `label` parameter is optional, and defaults to a text view.
    ///
    /// Parameters:
    /// - sourceItems: The list of all items to read from.
    /// - selectedItems: A binding to the values we want to track.
    /// - label: A closure that returns a view for each item.
    public init(
        sourceItems: [String],
        selectedItems: Binding<[String]>,
        @ViewBuilder label: @escaping (_ item: String) -> Label? = { item in
            Text(item)
        }
    ) {
        self.sourceItems = sourceItems
        self._selectedItems = selectedItems
        self.label = label
    }

    /// The body of the view
    public var body: some View {
        Form {
            List {
                ForEach(sourceItems, id: \.self) { item in
                    Button {
                        if self.selectedItems.contains(item) {
                            self.selectedItems.removeAll(where: { $0 == item })
                        } else {
                            self.selectedItems.append(item)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(
                                    self.selectedItems.contains(item)
                                    ? 1.0
                                    : 0.0
                                )
                                .foregroundStyle(Color.accentColor)
                                .accessibilityLabel("Selected")

                            label(item)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
#if os(iOS)
        .listStyle(.grouped)
#endif
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    @Previewable @State var selectedItems: [String] = []
    let items = ["star", "person", "rainbow"]

    MultiSelectView(
        sourceItems: items,
        selectedItems: $selectedItems
    ) { item in
        Label(item, systemImage: item)
    }
}
#endif
#endif
