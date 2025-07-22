//
//  IndexedList.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))
import SwiftUI

/// IndexedList is a view that displays a list of items grouped by their initial letter.
/// It allows for quick navigation to sections of the list \
/// by tapping on the initial letters displayed on the right side of the view.
/// The list is scrollable and each item can be customized using a cell builder closure.
public struct IndexedList<Cell: View>: View {
    /// The data to be displayed in the list, grouped by initial letter.
    private let listData: [String: [String]]

    /// A closure that builds the view for each cell in the list.
    /// It takes a string (the item name) and returns a view of type `Cell
    private let cellBuilder: (String) -> Cell

    /// Initializes an IndexedList with a list of strings.
    /// The strings are grouped by their initial letter, \
    /// and each item is displayed using the provided cell builder closure.
    /// - Parameters:
    ///   - data: An array of strings to be displayed in the list.
    ///   - rowContent: A closure that takes a string and returns a \
    ///     view of type `Cell` to be used as the content for each row in the list.
    /// - Example:
    /// ```swift
    /// IndexedList(data: ["Apple", "Banana", "Cherry"]) { name in
    ///     Text(name)
    /// }
    /// ```
    public init(
        data: [String],
        @ViewBuilder rowContent: @escaping (String) -> Cell
    ) {
        // Grouping the data by the first letter of each string, converting it to uppercase
        // This creates a dictionary where the keys are the first letters and the values are arrays of strings
        // This allows for quick access to items based on their initial letter
        // The keys are sorted alphabetically to maintain a consistent order in the list
        listData = Dictionary(grouping: data) { name in
            String(name.prefix(1)).uppercased()
        }

        // Assigning the provided rowContent closure to the cellBuilder property
        // This closure will be used to build the view for each cell in the list
        self.cellBuilder = rowContent
    }

    /// The current index that is being hovered over or tapped.
    @State private var currentIndex: String?

    /// A list of index key frames used for determining the position of each indexed letter.
    /// This is used to handle hover and drag gestures for scrolling.
    @State private var indexKeyFrames: [IndexKeyInfo] = []

    /// The body of the IndexedList view.
    public var body: some View {
        let sortedKeys = Array(listData.keys).sorted()

        // Using ScrollViewReader to allow programmatic scrolling to sections
        ScrollViewReader { proxy in
            // The main ZStack contains the background color, the List, and the indexed letter column
            ZStack(alignment: .topTrailing) {
                // MARK: - Background Color
                // Dynamic background color based on the platform
                bgColor

                // MARK: - List
                // List displaying the items grouped by their initial letter
                List {
                    // Using ForEach to iterate over the sorted keys of the listData dictionary
                    ForEach(sortedKeys, id: \.self) { key in
                        // Unwrapping the items for the current key
                        if let items = listData[key] {
                            // For each key, we create a section with the header as the key    
                            Section(header: Text(key).id(key)) {
                                // Using ForEach to iterate over the items in each section
                                ForEach(items, id: \.self) { name in
                                    // Building the cell using the provided cell builder closure
                                    cellBuilder(name)
                                }
                            }
                        }
                    }
                }
                // Add extra padding to the list to avoid clipping the indexed letter column
                .padding(.trailing, 10)
                // Hide the scroll indicators for a cleaner look
                .scrollIndicators(.hidden)

                // MARK: - Indexed Letter Column
                // Using a GeometryReader to create a vertical column of indexed letters
                // This column allows users to quickly navigate to sections of the list
                GeometryReader { geo in
                    // A vertical stack containing the indexed letters
                    VStack(spacing: 8) {
                        // Using ForEach to iterate over the sorted keys
                        // Each key is displayed as a tappable text view
                        ForEach(sortedKeys, id: \.self) { key in
                            // Displaying the key as a tappable text view
                            Text(key)
                                // Add some padding to make it easier to tap
                                .padding(.horizontal, 10)
                                .font(.caption2)
                                .foregroundStyle(currentIndex == key ? .blue : Color.accentColor)
                                // Add some general padding
                                .padding(2)
                                // On tap gesture to scroll to the section corresponding to the key
                                .onTapGesture {
                                    proxy.scrollTo(key, anchor: .top)
                                }
                                // Adding a background to add the GeometryReader
                                .background(
                                    // Using GeometryReader to capture the frame of each index key
                                    // For enabling scrubbing on iOS
                                    GeometryReader { proxy in
                                        Color.clear.preference(
                                            key: IndexKeyPreferenceKey.self,
                                            value: [IndexKeyInfo(key: key, frame: proxy.frame(in: .global))]
                                        )
                                    }
                                )
                                // Accessibility traits to make it clear that this is a link
                                .accessibilityAddTraits(.isLink)
                                // Adding hover effect for macOS
                                .onHover { hovering in
                                    if hovering {
                                        currentIndex = key
                                        proxy.scrollTo(key, anchor: .top)
                                    }
                                }
                        }
                    }
                    // Add some trailing padding to the indexed letter column, \
                    // to avoid the text being too close to the edge
                    .padding(.trailing, 8)
                    // Make the height 100% of the available space, \
                    // so it will be centered vertically
                    .frame(maxHeight: .infinity)
                    // Add a drag gesture to allow scrolling through the index
                    // This is particularly useful for iOS where scrubbing is common
                    // The drag gesture updates the current index based on the location of the drag
                    // and scrolls the list to the corresponding section
                    .gesture(
                        // Drag gesture to allow scrolling through the index
                        // For enabling scrubbing on iOS
                        DragGesture(minimumDistance: 1)
                            .onChanged { value in
                                // Check if the current index is nil or if it has changed
                                if let match = indexForLocation(
                                    value.location,
                                    in: geo.frame(in: .global),
                                    keyFrames: indexKeyFrames
                                ) {
                                    // If the current index is nil or has changed, update it and scroll to the section
                                    if currentIndex != match {
                                        currentIndex = match
                                        proxy.scrollTo(match, anchor: .top)
                                    }
                                }
                            }
                            .onEnded { _ in
                                // Reset the current index when the gesture ends
                                currentIndex = nil
                            }
                    )
                }
                // Add a preference key to capture the frames of the indexed letters
                .onPreferenceChange(IndexKeyPreferenceKey.self) { values in
                    self.indexKeyFrames = values
                }
                // Set the frame width of the indexed letter column
                // This ensures that the column has a fixed width for consistency
                // and to avoid layout issues
                .frame(width: 24)
            }
        }
    }

    /// A background color for the IndexedList view.
    /// This color adapts to the platform.
    /// - Returns: A `Color` that represents the background color of the IndexedList view.
    private var bgColor: some View {
#if os(macOS)
        Color(NSColor.windowBackgroundColor)
#else
        Color(UIColor.systemGroupedBackground)
#endif
    }

    /// Determines the index key for a given location in the indexed letter column.
    /// This function checks if the location falls within the frame of any indexed letter.
    /// - Parameters:
    ///   - location: The CGPoint representing the location of the gesture.
    ///   - container: The CGRect representing the frame of the indexed letter column.
    ///   - keyFrames: An array of `IndexKeyInfo` containing the keys and their corresponding frames.
    /// - Returns: The key of the indexed letter that corresponds to the location, or `nil` if no match is found.
    private func indexForLocation(
        _ location: CGPoint,
        in container: CGRect,
        keyFrames: [IndexKeyInfo]
    ) -> String? {
        // Check if the location is within the bounds of the indexed letter column
        for info in keyFrames where info.frame.contains(CGPoint(x: container.midX, y: location.y)) {
            return info.key
        }

        return nil
    }
}

// MARK: - IndexKeyInfo and PreferenceKey
/// A struct that holds information about an indexed letter key and its frame.
/// This is used to capture the frames of the indexed letters for scrubbing functionality.
/// It conforms to `Equatable` to allow comparison between instances.
struct IndexKeyInfo: Equatable {
    let key: String
    let frame: CGRect
}

/// A preference key that collects `IndexKeyInfo` instances.
/// This is used to store the frames of the indexed letters in the IndexedList view.
/// It conforms to `PreferenceKey` to allow the IndexedList view to update its state based \
/// on the frames of the indexed letters.
struct IndexKeyPreferenceKey: PreferenceKey {
    static var defaultValue: [IndexKeyInfo] = []
    static func reduce(value: inout [IndexKeyInfo], nextValue: () -> [IndexKeyInfo]) {
        value.append(contentsOf: nextValue())
    }
}

#Preview {
    IndexedList(data: [
        "Anne", "Bram", "Sanne", "Daan", "Lieke", "Milan", "Femke", "Joris", "Tess", "Thijs",
        "Noa", "Sem", "Lars", "Lotte", "Max", "Eva", "Luuk", "Nina", "Finn", "Roos",
        "Janneke", "Gijs", "Isa", "Koen", "Sofie", "Tijn", "Maud", "Ruben", "Evi", "Siem",
        "Luca", "Bo", "Jelle", "Fleur", "Mees", "Yara", "Pim", "Elin", "Stijn", "Mare",
        "Noud", "Saar", "Tim", "Bente", "Jochem", "Ilse", "Pepijn", "Marit", "Teun", "Milou",
        "Jip", "Jet", "Bas", "Anouk", "Timo", "Veerle", "Floris", "Lana", "Jens", "Mila",
        "Job", "Loes", "Cas", "Tirza", "Nick", "Fenna", "Hidde", "Lynn", "Dirk", "Jade",
        "Mark", "Iris", "Bart", "Elise", "Wout", "Norah", "Maarten", "Nora", "Kees", "Tessa",
        "Rik", "Amber", "Nathan", "Vera", "Roel", "Zara", "Jan", "Esmee", "Tom", "Britt",
        "Stef", "Demi", "Arjen", "Floor", "Johan", "Liv", "Harm", "Romy", "Martijn", "Suze"
    ]) { name in
        Text(name)
    }
}
#endif
