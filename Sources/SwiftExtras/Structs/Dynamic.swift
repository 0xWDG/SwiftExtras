//
//  Dynamic.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(ObjectiveC)
import Foundation
import ObjectiveC

/// A lightweight wrapper for Objective-C dynamic lookup and selector calls.
@dynamicCallable
@dynamicMemberLookup
public struct Dynamic {
    private let subject: AnyObject?
    private let memberName: String?

    /// The wrapped Objective-C object, class object, or dynamically fetched value.
    public var object: AnyObject? {
        guard let memberName else {
            return subject
        }

        return value(for: memberName) as AnyObject?
    }

    /// Creates a dynamic wrapper around an Objective-C object.
    /// - Parameter subject: The object to wrap.
    public init(_ subject: AnyObject?) {
        self.subject = subject
        self.memberName = nil
    }

    /// Creates a dynamic wrapper around an Objective-C class name.
    /// - Parameter className: The Objective-C runtime class name.
    public init(classNamed className: String) {
        self.subject = NSClassFromString(className)
        self.memberName = nil
    }

    private init(subject: AnyObject?, memberName: String?) {
        self.subject = subject
        self.memberName = memberName
    }

    /// Returns a dynamic wrapper for the named member.
    /// - Parameter member: The property or selector name.
    /// - Returns: A dynamic wrapper for the member.
    public subscript(dynamicMember member: String) -> Dynamic {
        Dynamic(subject: subject, memberName: member)
    }

    /// Reads and writes a key-value coding property on the wrapped object.
    /// - Parameter key: The key-value coding key.
    /// - Returns: The wrapped property value.
    public subscript(_ key: String) -> Dynamic {
        get {
            Dynamic(value(for: key) as AnyObject?)
        }

        nonmutating set {
            setValue(newValue.object, for: key)
        }
    }

    /// Calls the selected dynamic member as an Objective-C selector.
    /// - Parameter arguments: Arguments to pass to the selector. Up to two arguments are supported.
    /// - Returns: A dynamic wrapper around the returned object, if any.
    public func dynamicallyCall(withArguments arguments: [Any]) -> Dynamic {
        guard let memberName else {
            return Dynamic(nil)
        }

        return call(memberName, with: arguments.map { $0 as AnyObject })
    }

    /// Calls an Objective-C selector on the wrapped object.
    /// - Parameters:
    ///   - selectorName: The selector name. Colons are inferred when omitted.
    ///   - arguments: Arguments to pass to the selector. Up to two arguments are supported.
    /// - Returns: A dynamic wrapper around the returned object, if any.
    public func call(_ selectorName: String, with arguments: [Any?] = []) -> Dynamic {
        let objectArguments = arguments.map { argument in
            argument.map { $0 as AnyObject }
        }

        return invoke(selectorName, arguments: objectArguments)
    }

    /// Casts the wrapped object or dynamically fetched value to the requested type.
    /// - Parameter type: The type to cast to.
    /// - Returns: The wrapped value as the requested type, or nil if the cast fails.
    public func `as`<Value>(_ type: Value.Type = Value.self) -> Value? {
        object as? Value
    }

    private func value(for key: String) -> Any? {
        guard let subject = subject as? NSObject else {
            return nil
        }

        return subject.value(forKey: key)
    }

    private func setValue(_ value: Any?, for key: String) {
        guard let subject = subject as? NSObject else {
            return
        }

        subject.setValue(value, forKey: key)
    }

    private func call(_ selectorName: String, with arguments: [AnyObject]) -> Dynamic {
        invoke(selectorName, arguments: arguments.map(Optional.some))
    }

    private func invoke(_ selectorName: String, arguments: [AnyObject?]) -> Dynamic {
        guard arguments.count <= 2,
              let subject = subject as? NSObjectProtocol else {
            return Dynamic(nil)
        }

        let selector = Selector(selectorName.normalizedSelectorName(argumentCount: arguments.count))
        guard subject.responds(to: selector) else {
            return Dynamic(nil)
        }

        let result: Unmanaged<AnyObject>?
        switch arguments.count {
        case 0:
            result = subject.perform(selector)
        case 1:
            result = subject.perform(selector, with: arguments[0])
        case 2:
            result = subject.perform(selector, with: arguments[0], with: arguments[1])
        default:
            result = nil
        }

        return Dynamic(result?.takeUnretainedValue())
    }
}

private extension String {
    func normalizedSelectorName(argumentCount: Int) -> String {
        guard argumentCount > 0, !contains(":") else {
            return self
        }

        return self + String(repeating: ":", count: argumentCount)
    }
}
#endif
