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

public extension Data {
    /// Data as hexidecimal string
    ///
    /// Data as hexidecimal string representation
    var hexString: String {
        map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    /// Data as string (utf8)
    ///
    /// Data as string representation
    var stringValue: String? {
        String(data: self, encoding: .utf8)
    }
}

#if canImport(Compression)
extension Data {
    /// Config (for (de)compression)
    fileprivate typealias Config = (
        operation: compression_stream_operation,
        algorithm: compression_algorithm
    )

    /// (de)compression
    ///
    /// Perform the (de)compression
    ///
    /// - Parameters:
    ///   - config: Configuration
    ///   - source: Source ponter
    ///   - sourceSize: Source size
    ///   - preload: Data (leave empty)
    /// - Returns: (de)Compress data
    fileprivate func perform(
        config: Config,
        source: UnsafePointer<UInt8>,
        sourceSize: Int,
        preload: Data = Data()
    ) -> Data? {
        guard config.operation == COMPRESSION_STREAM_ENCODE || sourceSize > 0
        else { return nil }

        let streamBase = UnsafeMutablePointer<compression_stream>
            .allocate(capacity: 1)
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

        stream.dst_ptr = buffer
        stream.dst_size = bufferSize
        stream.src_ptr = source
        stream.src_size = sourceSize
        var resource = preload
        let flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)

        while true {
            switch compression_stream_process(&stream, flags) {
            case COMPRESSION_STATUS_OK:
                guard stream.dst_size == 0
                else {
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
    /// - note: Fixed at compression level 5 (best trade off between speed and
    /// time)
    ///
    /// - returns: raw deflated data according to
    /// [RFC-1951](https://tools.ietf.org/html/rfc1951).
    public func deflate() -> Data? {
        withUnsafeBytes { (rawBufferPtr: UnsafeRawBufferPointer) -> Data? in
            guard let baseAddress = rawBufferPtr.baseAddress
            else {
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
    /// - note: Self is expected to be a raw deflate, \
    /// stream according to [RFC-1951](https://tools.ietf.org/html/rfc1951).
    ///
    /// - returns: uncompressed data
    public func inflate() -> Data? {
        withUnsafeBytes { (rawBufferPtr: UnsafeRawBufferPointer) -> Data? in
            guard let baseAddress = rawBufferPtr.baseAddress
            else {
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
