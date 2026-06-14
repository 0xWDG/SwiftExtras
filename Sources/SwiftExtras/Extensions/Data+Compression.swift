//
//  Data+Compression.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if canImport(Compression)
import Compression
#endif

extension Data {
    /// A lowercase hexadecimal representation of the data.
    public var hexString: String {
        return self.map({
            return String(format: "%02hhx", $0)
        }).joined()
    }

    /// A UTF-8 string representation of the data, or `nil` when decoding fails.
    public var stringValue: String? {
        return String(data: self, encoding: .utf8)
    }
}

#if canImport(Compression)
extension Data {
    /// Config (for (de)compression)
    fileprivate typealias Config = (
        operation: compression_stream_operation,
        algorithm: compression_algorithm
    )

    /// Performs a streaming compression or decompression operation.
    ///
    /// - Parameters:
    ///   - config: The compression operation and algorithm.
    ///   - source: A pointer to the source bytes.
    ///   - sourceSize: The number of source bytes.
    ///   - preload: Data to prepend to the result.
    /// - Returns: The processed data, or `nil` if compression fails.
    fileprivate func perform(
        config: Config,
        source: UnsafePointer<UInt8>,
        sourceSize: Int,
        preload: Data = Data()
    ) -> Data? {
        guard config.operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0 else { return nil }

        let streamBase = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
        defer {
            streamBase.deallocate()
        }

        var stream = streamBase.pointee
        let status = compression_stream_init(
            &stream,
            config.operation,
            config.algorithm
        )

        guard status != COMPRESSION_STATUS_ERROR else { return nil }
        defer {
            compression_stream_destroy(&stream)
        }

        let bufferSize = Swift.max(Swift.min(sourceSize, 64 * 1024), 64)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }

        stream.dst_ptr  = buffer
        stream.dst_size = bufferSize
        stream.src_ptr  = source
        stream.src_size = sourceSize
        var resource = preload
        let flags: Int32 = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)

        while true {
            switch compression_stream_process(&stream, flags) {
            case COMPRESSION_STATUS_OK:
                guard stream.dst_size == 0 else {
                    return nil
                }
                resource.append(buffer, count: stream.dst_ptr - buffer)
                stream.dst_ptr = buffer
                stream.dst_size = bufferSize
            case COMPRESSION_STATUS_END:
                resource.append(buffer, count: stream.dst_ptr - buffer)
                return resource
            default:
                return nil
            }
        }
    }

    /// Compresses data using the zlib deflate algorithm.
    ///
    /// This method compresses the data using the zlib deflate algorithm.
    ///
    /// Example:
    /// ```swift
    /// let data = "Hello World!".data(using: .utf8)
    /// let compressed = data?.deflate()
    /// ```
    ///
    /// - Note: The Compression framework chooses the compression level.
    /// - Returns: Raw deflated data according to [RFC 1951](https://www.rfc-editor.org/rfc/rfc1951), or `nil` on failure.
    public func deflate() -> Data? {
        return self.withUnsafeBytes { (rawBufferPtr: UnsafeRawBufferPointer) -> Data? in
            guard let baseAddress = rawBufferPtr.baseAddress else {
                return nil
            }

            let sourcePtr = baseAddress.assumingMemoryBound(to: UInt8.self)

            let configuration = (
                operation: COMPRESSION_STREAM_ENCODE,
                algorithm: COMPRESSION_ZLIB
            )

            return perform(
                config: configuration,
                source: sourcePtr,
                sourceSize: count
            )
        }
    }

    /// Decompresses the data using the zlib deflate algorithm.
    ///
    /// This method decompresses the data using the zlib deflate algorithm.
    ///
    /// Example:
    /// ```swift
    /// let data = "Hello World!".data(using: .utf8)
    /// let compressed = data?.deflate()
    /// let decompressed = compressed?.inflate()
    /// ```
    ///
    /// - Note: The receiver must contain a raw deflate stream according to
    ///   [RFC 1951](https://www.rfc-editor.org/rfc/rfc1951).
    /// - Returns: The uncompressed data, or `nil` when decompression fails.
    public func inflate() -> Data? {
        return self.withUnsafeBytes { (rawBufferPtr: UnsafeRawBufferPointer) -> Data? in
            guard let baseAddress = rawBufferPtr.baseAddress else {
                return nil
            }

            let sourcePtr = baseAddress.assumingMemoryBound(to: UInt8.self)

            let configuration = (
                operation: COMPRESSION_STREAM_DECODE,
                algorithm: COMPRESSION_ZLIB
            )

            return perform(
                config: configuration,
                source: sourcePtr,
                sourceSize: count
            )
        }
    }
}
#endif
