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

// MultiSelectPickerView
//
// This is a picker view that allows you to select multiple items from a list.
// It displays a list of items, each with a checkbox that allows you to select or deselect it.
public struct MultiSelectPickerView<PickerLabel: View, SelectionLabel: View>: View {
    /// The list of all items to read from
    @State var sourceItems: [String]

    /// The values we want to track
    @Binding var selectedItems: [String]

    /// The picker label
    var pickerLabel: () -> PickerLabel

    /// The label for each item
    var selectionLabel: (_ item: String) -> SelectionLabel?

    // MultiSelectPickerView
    //
    // This is a picker view that allows you to select multiple items from a list.
    // It displays a list of items, each with a checkbox that allows you to select or deselect it.
    //
    // Usage:
    // ```
    // NavigationLink {
    //     List {
    //         MultiSelectPickerView(
    //             sourceItems: items,
    //             selectedItems: $selectedItems) {
    //                 Text("Pick your items")
    //             } selectionLabel: { item in
    //                 Label(item, systemImage: item)
    //             }
    //     }
    // }
    // ```
    //
    // The `label` parameter is optional, and defaults to a text view.
    //
    // Parameters:
    // - sourceItems: The list of all items to read from.
    // - selectedItems: A binding to the values we want to track.
    // - pickerLabel: A closure that returns a label for the picker.
    // - selectionLabel: A closure that returns a label for each item.
    public init(
        sourceItems: [String],
        selectedItems: Binding<[String]>,
        @ViewBuilder pickerLabel: @escaping () -> PickerLabel,
        @ViewBuilder selectionLabel: @escaping (_ item: String) -> SelectionLabel? = { item in
            Text(item)
        }
    ) {
        self.sourceItems = sourceItems
        self._selectedItems = selectedItems
        self.pickerLabel = pickerLabel
        self.selectionLabel = selectionLabel
    }

    /// The body of the view
    public var body: some View {
        NavigationLink {
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

                                selectionLabel(item)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
#if os(iOS)
            .listStyle(.grouped)
#endif
            } label: {
            pickerLabel()
        }
    }
}

struct MultiSelectPickerViewPreviews: PreviewProvider {
    static var items = ["star", "person", "rainbow"]
    @State static var selectedItems: [String] = []

    static var previews: some View {
        NavigationView {
            List {
                MultiSelectPickerView(
                    sourceItems: items,
                    selectedItems: $selectedItems) {
                        Text("Pick your items")
                    } selectionLabel: { item in
                        Label(item, systemImage: item)
                    }
            }
        }
    }
}
#endif
