# Functions

SwiftExtras exposes standalone functions for work that does not naturally
belong to a type. Their DocC comments define their inputs, outputs, failure
behavior, platform availability, and side effects.

## Image and Color Processing

``kMeansCluster(colors:clusters:iterations:)`` groups SwiftUI colors into a
requested number of RGB centroids. Use it for palette reduction or color
analysis, not for color-space-accurate image processing: the algorithm measures
distance in RGB space and returns an empty array for invalid cluster requests.

``gravatarAvatarImage(emailAddress:size:defaultImage:rating:session:)``
retrieves a Gravatar image asynchronously. Provide a custom URL session when
you need to control caching, authentication, or test transport behavior. Treat
a `nil` result as an unavailable avatar and provide an accessible fallback in
the calling interface.

## URL Handling

``openURL(_:)`` has overloads for string and `URL` input. Each validates its
input and delegates opening to the current platform, returning whether it could
begin the request. It does not prove that a remote destination is reachable or
that the user completed a navigation.

## Operators

The regular-expression match operators `=~` and `!~` test a string against a
pattern, while the optional binding operator provides a
non-optional `Binding` fallback. Their declarations include the exact matching
and binding semantics; prefer explicit APIs when an operator would obscure the
intent of a call site.

## Related Documentation

- <doc:Extensions>
- <doc:FoundationUtilities>
