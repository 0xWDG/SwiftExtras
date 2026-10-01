# Extensions

SwiftExtras extends standard-library, Foundation, SwiftUI, UIKit, and AppKit
types with focused APIs. Every extension and function declaration has DocC
comments in source; use this article to choose the appropriate family before
opening a symbol's reference page.

## Standard Library and Foundation

Collection and numeric extensions provide safe indexing, aggregate values,
formatting, clamping, and unit conversion. `Optional` utilities distinguish an
absent collection from a populated value, while `Sequence` and `Collection`
helpers avoid repeated boilerplate for sums and averages.

`String`, `StringProtocol`, and `LocalizedStringKey` extensions cover text
cleanup, slicing, quoting, Base64 encoding, URL creation, fuzzy matching, ANSI
formatting, and localization. These APIs retain Swift's character-safe string
semantics; methods that can fail return an optional rather than silently
inventing a result.

`Data`, `Date`, `URL`, `URLSession`, `Locale`, `UserDefaults`,
`ProcessInfo`, and `Notification.Name` extensions provide platform-aware
utilities for serialization, relative time, reachability, persistence, and
runtime context. Check each symbol's availability and failure behavior before
using it with external input or network resources.

## SwiftUI

`View` extensions supply composition helpers, view-size and scroll-position
readers, asynchronous tasks, change observation, error presentation, layout
adaptation, snapshots, onboarding, and accessibility-preserving effects.
Apply them close to the view they modify so state ownership and modifier order
remain clear.

`Binding`, `Color`, `Image`, `Text`, and `Task` extensions make common SwiftUI
work declarative. Bindings retain their original source of truth; image and
color helpers may be platform- or actor-constrained; and task helpers respect
Swift concurrency cancellation whenever the underlying API supports it.

## Platform Integration

`PlatformImage`, `PlatformViewRepresentable`, `NSImage`, `NSPasteboard`, and
`UIDevice` extensions isolate UIKit and AppKit differences behind the
cross-platform types exposed by SwiftExtras. Use the platform-neutral API when
possible, and guard platform-specific behavior with the documented availability
requirements.

## Protocol Conformances

Some extensions add retroactive conformances, including support for
identification, coding, raw values, localized errors, and sendability. These
conformances are documented beside their declarations. Review their identity
and serialization semantics before relying on them for persistent data or
collection identity.

## Related Documentation

- <doc:StringUtilities>
- <doc:FoundationUtilities>
- <doc:CustomViews>
