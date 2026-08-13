# String Utilities

Format and divide strings with small convenience APIs.

## Overview

Use ``Swift/StringProtocol/quoted`` to enclose a value in double quotation marks
for display or logging. Existing quotation marks and backslashes are escaped:

```swift
let message = "SwiftExtras".quoted
// "SwiftExtras"

let escaped = "Say \"hello\"".quoted
// "Say \"hello\""
```

Use ``Swift/String/split(every:)`` to divide text into groups of a fixed maximum
size. The method operates on Swift characters, so extended grapheme clusters such
as emoji remain intact.

```swift
let groups = "SwiftExtras".split(every: 5)
// ["Swift", "Extra", "s"]
```

The group size must be greater than zero.

## Topics

### Formatting

- ``Swift/StringProtocol/quoted``

### Grouping

- ``Swift/String/split(every:)``
