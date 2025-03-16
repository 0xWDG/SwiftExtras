# Changelog

This file contains the changelog of SwiftExtras.

### 1.1.8
https://github.com/0xWDG/SwiftExtras/compare/1.1.0...1.1.8
https://github.com/0xWDG/SwiftExtras/commit/bb3d362657ddb0b3345d8f7431312748c93dd3c3

- Added this changelog.
- Made [`HorizontalStepper`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/horizontalstepper) public.
- Made [`formEncoded`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/formencoded) public.

### 1.1.7
https://github.com/0xWDG/SwiftExtras/compare/1.1.6...1.1.7

### 1.1.6
https://github.com/0xWDG/SwiftExtras/compare/1.1.5...1.1.6

### 1.1.5
https://github.com/0xWDG/SwiftExtras/compare/1.1.4...1.1.5

### 1.1.4
https://github.com/0xWDG/SwiftExtras/compare/1.1.3...1.1.4

### 1.1.3
https://github.com/0xWDG/SwiftExtras/compare/1.1.2...1.1.3

### 1.1.2
https://github.com/0xWDG/SwiftExtras/compare/1.1.1...1.1.2

### 1.1.1
https://github.com/0xWDG/SwiftExtras/compare/1.1.0...1.1.1

### 1.1.0
https://github.com/0xWDG/SwiftExtras/compare/1.0.9...1.1.0

### 1.0.9
https://github.com/0xWDG/SwiftExtras/compare/1.0.8...1.0.9

### 1.0.8 (Made a typo in this release)
- Added [`SwiftLint`](https://0xwdg.github.io/SwiftExtras/documentation/swiftlint) rules  
  Added SwiftLint to the project
- Added [`userCountry`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/usercountry) to `Locale`  
  This property returns the user's country
- Added [`userLanguage`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/userlanguage) to `Locale`  
  This property returns the user's language
- Added [`userCurrencyCode`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/usercurrencycode) to `Locale`  
  This property returns the user's currency code
- Added [`userCurrencySymbol`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/usercurrencysymbol) to `Locale`
- Added [`deviceMeasurementSystem`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/devicemeasurementsystem) to `Locale`  
  This property returns the device's measurement system
- Added [`userTimeZone`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/usertimezone) to `Locale`  
  This property returns the user's time zone
- Added [`userCalendar`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/usercalendar) to `Locale`  
  This property returns the user's calendar
- Added [`collationIdentifier`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/locale/collationidentifier) to `Locale`  
  This property returns the collation identifier
- Added [`isXcodePreview`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isxcodepreview) to `ProcessInfo`  
  This property returns true if the app is running in an Xcode preview
- Added [`isUITesting`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isuitesting) to `ProcessInfo`  
  This property returns true if the app is running UI tests
- Added [`isUnitTesting`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isunittesting) to `ProcessInfo`  
  This property returns true if the app is running unit tests
- Added [`isLowPowerModeActive`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/islowpowermodeactive) to `ProcessInfo`  
  This property returns true if the device is in low power mode
- Added [`currentSystemUptime`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/currentsystemuptime) to `ProcessInfo`  
  This property returns the current system uptime
- Added [`systemUptimeInDays`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/systemuptimeindays) to `ProcessInfo`  
  This property returns the system uptime in days
- Added [`isRunningOnMacCatalyst`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isrunningonmaccatalyst) to `ProcessInfo`  
  This property returns true if the app is running on Mac Catalyst
- Added [`isRunningiOSAppOnMac`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isrunningiosapponmac) to `ProcessInfo`  
  This property returns true if the app is running an iOS app on Mac
- Added [`contains(_:casesensitive:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/contains(_:casesensitive:)) to `String`  
  This function checks if a string contains an value
- Added [`trimmed(for:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/trimmed(for:)) to `String`  
  This property returns the trimmed string
- Improved `urlEncoded`.
  It does not force unwrap the string anymore
- Added [`formEncoded`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/formencoded) to `String`  
  This property returns the form encoded string
- Added [`deviceName`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicename) to `UIDevice` (iOS only)  
  This property returns the device name
- Added [`deviceSystemName`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicesystemname) to `UIDevice` (iOS only)  
  This property returns the device system name
- Added [`deviceSystemVersion`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicesystembersion) to `UIDevice` (iOS only)
- Added [`deviceModel`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicemodel) to `UIDevice` (iOS only)  
  This property returns the device model
- Added [`deviceIdentifierForVendor`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/deviceIdentifierforvendor) to `UIDevice` (iOS only)  
  This property returns the device identifier for vendor
- Added [`isiPad`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/isipad) to `UIDevice` (iOS only)  
  This property returns true if the device is an iPad
- Added [`isiPhone`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/isiphone) to `UIDevice` (iOS only)
- Added [`deviceBatteryLevel`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicebatterylevel) to `UIDevice` (iOS only)  
  This property returns the device battery level
- Added [`deviceBatteryState`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/devicebatterystate) to `UIDevice` (iOS only)  
  This property returns the device battery state
- Added [`deviceOrientation`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/deviceorientation) to `UIDevice` (iOS only)  
  This property returns the device orientation
- Added [`isPortraitMode`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/isportraitmode) to `UIDevice` (iOS only)  
  This property returns true if the device is in portrait mode
- Added [`isLandscapeMode`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/uidevice/islandscapemode) to `UIDevice` (iOS only)  
  This property returns true if the device is in landscape mode
- Added [`.dismissKeyboardOnTap()`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/dismisskeyboardontap()) to `View`  
  This view modifier dismisses the keyboard on tap
- Added [`pulsating()`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/pulsating()) to `View`  
  This view modifier adds a pulsating effect to a view
- Added [`shake(_:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/shake(_:)) to `View`  
  This view modifier adds a shake effect to a view

### 0.1.7
- visionOS specific fixes.
  Fixes compilation errors on visionOS.
- Added [`formatted(_:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/date/formatted(_:)) to `Date`  
  This function formats a date with a date style and a time style
- Added [`urlDecoded`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/urldecoded) to `String`  
  This property returns the URL decoded string
- Added [`urlEncoded`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/urlencoded) to `String`
    This property returns the URL encoded string
- Added [`.onLandscape`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/onlandscape(transform:)) to `View`  
  This view modifier performs an action when the device is in landscape orientation
- Added [`.onPortrait`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/onportrait(transform:)) to `View`  
  This view modifier performs an action when the device is in portrait orientation
- Added [`SafariView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/safariview) (iOS only)  
  This view is a wrapper around `SFSafariViewController`

### 0.1.6
- Added localization support.  
  SwiftExtras now supports localization.
- Added [`HorizontalStepper`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/horizontalstepper) view  
  A horizontal stepper that can be used for onboarding
- Improvements to `SEAcknowledgementsView`  
  Prevent double entries
- Improvements to `SESettingsView`
  You can now add custom top and bottom content

### 0.1.5
- Added MultiPlatform support to `Image` with [`init(platformimage:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/image/init(platformimage:))  
  This initializer creates an image for the current platform
- Added [`isSwiftUIPreview`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/processinfo/isswiftuipreview) to `ProcessInfo`  
  This property returns true if the app is running in a SwiftUI preview
- [Made `String` conform to `LocalizedError`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/localizederror-implementations)  
  This allows to create a localized error with a string
- [Added `.if` to `View`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/if(_:transform:))  
  This view modifier conditionally applies a view modifier
- [Added `.modifier` to `View`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/modifier(transformation:))  
  This view modifier conditionally applies a view modifier
- [Added `string` to `NSPasteBoard`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appkit/nspasteboard/string)  
  This property returns the string of the pasteboard
- Created `PlatformViewRepresentable.swift`  
  To support multiplatform
- Created [`PlatformViewRepresentable`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/platformviewrepresentable)  
  A protocol that represents a view that is platform specific
- Multiplatform improvements
  macOS specific fixes

### 0.1.4
- Added Acknowledgements to [`SESettingsView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sesettingsview)
- Added [`SEAcknowledgement`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/seacknowledgement) struct  
  This is used to represent an acknowledgement
- Added [`SEAcknowledgementsView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/seacknowledgementsview) view  
  This is used to display acknowledgements

### 0.1.3
- Cache AppStore results
- Fixed fetching icons on macOS
- Extracted [`SEChangeLogEntry`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sechangelogentry) to its own file
- Extracted [`SEChangeLogView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sechangelogview) to its own file
- Improved [`SESettingsView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sesettingsview)  
  Support for custom settings

### 0.1.2
- Improved AppStore related functions
- Renamed `SKAppInfoAppStoreInfo` to [`SEAppInfoAppStoreInfo`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/seappinfoappstoreinfo)
- Renamed `SKAppInfoAppStoreResult` to [`SEAppInfoAppStoreResult`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/seappinfoappstoreresult)
- Improved documentation

### 0.1.1
- Multiplatform improvements

### 0.1.0
- Multiplatform improvements
- [Added `appStoreInfo()` to `AppInfo`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/appstoreinfo())  
  This function returns the app store info of the app (identifier, developer identifier)
- [Added `getReviewURL()` to `AppInfo`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/getreviewurl())  
  This function returns the review URL of the app
- [Added `getDeveloperURL()` to `AppInfo`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/getdeveloperurl())  
  This function returns the developer URL of the app
- [Added `AsyncView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/asyncview)  
  This view is a view that loads its content asynchronously
- Renamed `SEChangeLog` to []`SEChangeLogView`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sechangelogview)  
  This view is a view that displays the change log of the app

### 0.0.8
- Fixed assets not being copied to the correct target
  To support the social icons
- Made `slufigied` public.
- Removed some debug code

### 0.0.7
- [Added .bundleIdentifier` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/bundleidentifier)  
  This property returns the bundle identifier of the app
- Added social icons  
  (bluesky, discord, discourse, facebook, github, instagram, linkedin, mastodon, matrix, microblog, reddit, slack, telegram, threads, tiktok, twitter, youtube)
- [Added `slugified` to `String`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/string/slugified)  
  A function that slugifies a string
- [Added `openURL(_:)`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/openurl(_:))  
  support opening URLs in a multiplatform way
- [Added `SESettingsView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sesettingsview)  
  This view is a settings view that is similar to the settings view in the Settings app

### 0.0.6
- Improved documentation
- [Added `subscript(safe: )` to `Collection`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swift/collection/subscript(safe:))  
  To safely access an element in a collection
- [Improved `WebView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/webview)  
  Added `onLoad` and `onError` to the `WebView` view

### 0.0.5
- [Added `isAppExtension` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/isappextension)  
    These properties return true if the app is an app extension
- [Added `isRunningTests` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/isrunningtests)  
    These properties return true if the app is running tests
- [Added `isRunningUITests` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/isrunninguitests)  
    These properties return true if the app is running UI tests
- [Added `schemes` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/schemes)  
    This property returns the schemes of the app
- [Added `mainScheme` to `AppInfo` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/appinfo/mainscheme)  
    This property returns the main scheme of the app
- [Added `isCarplay` to `Device` struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/device/iscarplay) (iOS only)  
   A property that returns true if the device is a CarPlay device
- [Added `.onChange` modifier to `Binding<V>`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/binding/onchange(_:))  
  A view modifier that observes changes in a binding
- Added Data+Compression, [Deflate](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/data/deflate()), [Inflate](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/foundation/data/inflate())  
  Added compression and decompression to Data
- [Added `ANSIColors` enum](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/ansicolors)  
  An enum that represents ANSI colors
- Added String Subscripting.  
  To access a character in a string
- Added UserDefaults Subscripting.  
  To access UserDefaults with a subscript
- Fixed a compilation error in `View+getRootViewController.swift`  
  Multiplatform support
- Fixed a compilation error in `MailView.swift`  
  Multiplatform support
- [Added `.horizontallyCentered()` modifier to `View`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/horizontallycentered())  
  To center a view horizontally
- [Added `BlurView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/blurview)  
  Added a `BlurView` view that is a wrapper around `UIVisualEffectView`
- [Added `WebView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/webview)  
  Added a `WebView` view that is a wrapper around `WKWebView`  
- Added Multiplatform support
- [Added `CardView` view](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/cardview)  
  This view is a card view that is similar to the card view in the Maps app

### 0.0.4
- Fix logging (fixes [#1](https://github.com/0xWDG/SwiftExtras/issues/1))

### 0.0.3
- [Extension to make Color identifiable](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/color/identifiable-implementations)  
  An extension that makes `Color` identifiable
- [Random Color extension](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/color/random)  
  An extension that generates a random color  
- [Text extension foregroundLinearGradient](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/text/foregroundlineargradient(colors:startpoint:endpoint:if:))  
  An extension that sets the foreground color of a text to a linear gradient

### 0.0.2
- [.showError modifier](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/showerror(error:buttontitle:))  
  A view modifier that shows an error alert
- [.SaveSize modifier](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/swiftuicore/view/savesize(in:))  
  A view modifier that saves the size of the view
- [getRootViewController function](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/getrootviewcontroller) (iOS only)  
  A function that returns the root view controller
- [SensoryFeedback class](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/sensoryfeedback) (iOS only)  
  A class that provides haptic feedback
- [Optional binding operator `??`](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/__(_:_:))  
  A custom operator that allows to bind an optional value to a default value
- [TransparentBlurView struct](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/transparentblurview)  
  A view that represents a transparent blur view

### 0.0.1
- Initial release
- [MailView](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/mailview) struct (iOS only)  
  A view that represents a mail composer
- [Device enum](https://0xwdg.github.io/SwiftExtras/documentation/swiftextras/device)  
  A struct that represents the device
