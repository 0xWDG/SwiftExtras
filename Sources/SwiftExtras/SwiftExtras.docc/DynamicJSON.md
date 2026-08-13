# Dynamic JSON

Navigate heterogeneous JSON without declaring a model type first.

## Overview

``JSON`` represents objects, arrays, strings, numbers, Boolean values, and null.
Object keys support dynamic-member syntax, while arrays support safe indexed access.

```swift
let json = try JSON(data: data)
let name = json.user?.name?.string
let firstID = json.results?[0]?.id?.int
```

Accessors can perform common scalar conversions, such as numeric strings to
numbers and `"yes"` or `"no"` strings to Boolean values. Missing keys, invalid
indices, and incompatible conversions return `nil`.

Use ``JSON/object`` to obtain Foundation-compatible values or ``JSON/data(options:)``
to serialize the value again. Top-level JSON fragments are supported.

## Topics

### Creating Values

- ``JSON/init(data:options:)``
- ``JSON/init(_:)``

### Navigation

- ``JSON/subscript(_:)``

### Values and Conversion

- ``JSON/dictionary``
- ``JSON/array``
- ``JSON/string``
- ``JSON/number``
- ``JSON/double``
- ``JSON/int``
- ``JSON/bool``
- ``JSON/object``
- ``JSON/data(options:)``
