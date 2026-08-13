# Foundation Utilities

Inspect the current application and display dates relative to another moment.

## Relative Dates

Use ``Foundation/Date/timeAgo`` for a localized description relative to now, or
``Foundation/Date/timeAgo(relativeTo:)`` when you have a specific reference date.

```swift
let description = date.timeAgo
let historicalDescription = date.timeAgo(relativeTo: referenceDate)
```

Relative descriptions are localized and approximate. Their exact wording depends
on the user's locale and operating system.

## Device and Application Information

``DeviceInfo`` exposes bundle metadata and operating-system version components
without requiring callers to unwrap values from `Bundle` or `ProcessInfo`.

```swift
let appName = DeviceInfo.bundleName
let osVersion = DeviceInfo.systemVersionString
let isSandboxed = DeviceInfo.appIsSandboxed
```

Appearance and native icon properties are isolated to the main actor because
they consult UIKit or AppKit.

## Application Environment Metadata

``AppInfo`` provides accessibility parameters plus distribution, platform,
architecture, locale, screen, orientation, and time-zone metadata. These values
are useful when building diagnostics or analytics payloads.

```swift
let platform = AppInfo.platform
let architecture = AppInfo.architecture
let timeZone = AppInfo.timeZone
```

## Topics

### Relative Date Formatting

- ``Foundation/Date/timeAgo``
- ``Foundation/Date/timeAgo(relativeTo:)``

### Runtime Information

- ``DeviceInfo``
- ``AppInfo``
