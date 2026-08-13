# Custom Views

Use these compact iOS examples as a visual reference for the SwiftExtras SwiftUI views and layouts.

## Form Controls

`LabeledTextField` displays a placeholder that can float above the field when text is present.

![LabeledTextField examples on iOS](labeled-text-field-ios.png)

`LimitedTextField` adds a character counter below a standard text field.

![LimitedTextField example on iOS](limited-text-field-ios.png)

`MonthYearPickerView` presents month and year pickers side by side.

![MonthYearPickerView example on iOS](month-year-picker-view-ios.png)

## Selection

`MultiSelectView` displays selectable rows with visible selected-state indicators.

![MultiSelectView example on iOS](multi-select-view-ios.png)

`MultiSelectPickerView` exposes the same selection experience from a navigation row.

![MultiSelectPickerView example on iOS](multi-select-picker-view-ios.png)

## Actions

`ConfirmationButton` shows a destructive action that asks for confirmation before running.

![ConfirmationButton example on iOS](confirmation-button-ios.png)

`SplitActionButton` combines a primary action with a secondary menu action.

![SplitActionButton example on iOS](split-action-button-ios.png)

## Containers

`CardView` wraps custom content in a dismissible card-style presentation.

![CardView example on iOS](card-view-ios.png)

`DisclosureSection` creates an expandable section for grouped content.

![DisclosureSection example on iOS](disclosure-section-ios.png)

`CarouselView` displays images in a paged carousel with a progress indicator.

![CarouselView example on iOS](carousel-view-ios.png)

`HorizontalStepper` renders progress across a fixed number of steps.

![HorizontalStepper example on iOS](horizontal-stepper-ios.png)

`WStack` lays out children horizontally and wraps them to the next line when needed.

![WStack example on iOS](wstack-ios.png)

## Lists

`IndexedList` groups rows by first letter and displays an index rail for fast navigation.

![IndexedList example on iOS](indexed-list-ios.png)

`SEChangeLogView` renders versioned release notes.

![SEChangeLogView example on iOS](se-changelog-view-ios.png)

`SEAcknowledgementView` renders dependency acknowledgements.

![SEAcknowledgementView example on iOS](se-acknowledgement-view-ios.png)

## Notifications

`NotificationView` displays a compact notification banner.

![NotificationView example on iOS](notification-view-ios.png)

## Modifiers

### Scroll Tracking

Apply ``SwiftUICore/ScrollView/trackScrolling()`` to the scroll view inside a
`ScrollViewReader`, then use ``SwiftUICore/ScrollViewReader/onScrolled(_:)`` to
receive a normalized horizontal and vertical position from `0` through `1` on
iOS 16 and later.

![Scroll tracking modifier on iOS](scroll-tracking-modifier-ios.png)

```swift
@State private var position = UnitPoint.zero

ScrollViewReader { _ in
    ScrollView {
        LazyVStack {
            // Scrollable content
        }
    }
    .trackScrolling()
}
.onScrolled { position = $0 }
```

### Stretchy Headers

Use ``SwiftUICore/View/asStretchyHeader(startingHeight:coordinateSpace:)`` on a
view at the top of a scroll view. The view grows into the space revealed when
someone pulls beyond the top edge on iOS 16 and later.

![Stretchy header modifier on iOS](stretchy-header-modifier-ios.png)

```swift
ScrollView {
    header
        .asStretchyHeader(startingHeight: 220)

    content
}
```

### Island Toasts

Use ``SwiftUICore/View/islandToast(item:content:)`` to show a bottom-anchored,
non-blocking notification while an optional item is non-`nil`. Supply a
``IslandToastCard`` with a role, optional action, and presentation duration.
Island toasts require iOS 17 or later and use a compact-to-expanded transition
in an iPhone's compact horizontal size class.

![Island toast modifier on iOS](island-toast-modifier-ios.png)

```swift
@State private var toast: Toast?

content
    .islandToast(item: $toast) { _ in
        IslandToastCard(
            title: "Changes saved",
            subtitle: "Your project is up to date.",
            role: .success
        )
    }
```

### Picture in Picture

Use ``SwiftUICore/View/pictureInPicture(isPresented:)`` to present a view, or
``SwiftUICore/View/pictureInPicture(isPresented:content:)`` to provide separate
Picture in Picture content. Start presentation from an explicit user action and
enable the Audio, AirPlay, and Picture in Picture background mode in the app.
The modifiers support iOS 16 and later; test system presentation on a physical
device because simulator support can vary.

![Picture in Picture modifier on iOS](picture-in-picture-modifier-ios.png)

```swift
@State private var isPictureInPicturePresented = false

Button("Start Picture in Picture") {
    isPictureInPicturePresented = true
}
.accessibilityHint("Displays the player in a system Picture in Picture window")
.pictureInPicture(isPresented: $isPictureInPicturePresented) {
    PlayerView()
}
```

The modifier previews in the source are wrapped in `#if DEBUG`, so their fixtures
and preview declarations aren't included in production builds.

## Effects

Use ``SwiftUICore/View/shimmer()`` for the default loading effect or
``SwiftUICore/View/shimmering(active:animation:gradient:bandSize:mode:)`` to
customize its timing, gradient, band width, and compositing mode.

![Shimmer modifier on iOS](shimmer-modifier-ios.png)

```swift
Text("Loading")
    .redacted(reason: .placeholder)
    .shimmering(
        gradient: Gradient(colors: [.clear, .white, .clear]),
        mode: .overlay(blendMode: .screen)
    )
```

The shimmer follows left-to-right or right-to-left layout direction and disables
its motion when Reduce Motion is enabled.
