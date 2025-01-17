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
    var hexString: String {
        return self.map({
            return String(format: "%02hhx", $0)
        }).joined()
    }

    /// Data as string (utf8)
    var stringValue: String? {
        return String.init(data: self, encoding: .utf8)
    }
}

#if canImport(Compression)
public extension Data {
    /// Config (for (de)compression)
    fileprivate typealias Config = (
        operation: compression_stream_operation,
        algorithm: compression_algorithm
    )

    /// (de)compression)
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

    /// Compresses the data using the zlib deflate algorithm.
    /// - returns: raw deflated data according to [RFC-1951](https://tools.ietf.org/html/rfc1951).
    /// - note: Fixed at compression level 5 (best trade off between speed and time)
    func deflate() -> Data? {
        return self.withUnsafeBytesData { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
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
    /// - note: Self is expected to be a raw deflate, \
    /// stream according to [RFC-1951](https://tools.ietf.org/html/rfc1951).
    /// - returns: uncompressed data
    func inflate() -> Data? {
        return self.withUnsafeBytesData { (sourcePtr: UnsafePointer<UInt8>) -> Data? in
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

    /// withUnsafeBytes
    /// - Parameter body: Unsafe pointer
    /// - Throws: ResultType
    /// - Returns: ResultType
    func withUnsafeBytesData<ResultType, ContentType>(
        _ body: (UnsafePointer<ContentType>) throws -> ResultType
    ) rethrows -> ResultType {
        return try self.withUnsafeBytes({ (rawBufferPointer: UnsafeRawBufferPointer) -> ResultType in
            guard let baseAddress = try body(
                rawBufferPointer.bindMemory(
                    to: ContentType.self
                ).baseAddress else {
                    fatalError("Failed to bind memory")
                }

                return baseAddress
            )
        })
    }
}
#endif
