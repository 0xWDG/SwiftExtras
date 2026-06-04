//
//  Binding+Identifiable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-02-01.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License

#if canImport(SwiftUI)
import SwiftUI

extension Binding: Identifiable where Value: Identifiable {
    public var id: Value.ID {
        wrappedValue.id
    }
}

extension Binding: Sequence where
    Value: MutableCollection, Value: RandomAccessCollection, Value.Element: Identifiable {
    public typealias Element = Binding<Value.Element>

    public func makeIterator() -> BindingIterator {
        BindingIterator(collection: self)
    }

    public struct BindingIterator: IteratorProtocol {
        private let collection: Binding<Value>
        private var indices: Value.Indices.SubSequence

        fileprivate init(collection: Binding<Value>) {
            self.collection = collection
            self.indices = collection.wrappedValue.indices[...]
        }

        public mutating func next() -> Binding<Value.Element>? {
            guard let index = indices.popFirst() else { return nil }
            return collection[index]
        }
    }
}

extension Binding: Collection where
    Value: MutableCollection,
    Value: RandomAccessCollection,
    Value.Element: Identifiable {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices
    public typealias SubSequence = Binding<Value.SubSequence>

    public subscript(index: Value.Index) -> Binding<Value.Element> {
        var element0 = wrappedValue[index]
        let id = element0.id
        return Binding<Value.Element>(
            get: {
                let element = wrappedValue[index]
                if element.id == id {
                    element0 = element
                    return element
                } else {
                    if let element = wrappedValue.first(where: { $0.id == id }) {
                        element0 = element
                        return element
                    } else {
                        // Dummy value for dangling bindings
                        return element0
                    }
                }
            },
            set: { newValue in
                let element = wrappedValue[index]
                if element.id == id {
                    wrappedValue[index] = newValue
                } else {
                    if let index = wrappedValue.firstIndex(where: { $0.id == id }) {
                        wrappedValue[index] = newValue
                    } else {
                        // Ignores changes through dangling bindings
                    }
                }
            }
        )
    }

    public var indices: Value.Indices {
        wrappedValue.indices
    }

    public var startIndex: Value.Index {
        wrappedValue.startIndex
    }

    public var endIndex: Value.Index {
        wrappedValue.endIndex
    }

    public func index(after index: Value.Index) -> Value.Index {
        wrappedValue.index(after: index)
    }
}

extension Binding: BidirectionalCollection where
    Value: MutableCollection,
    Value: RandomAccessCollection,
    Value.Element: Identifiable {
    public func index(before index: Value.Index) -> Value.Index {
        wrappedValue.index(before: index)
    }
}

extension Binding: RandomAccessCollection where
    Value: MutableCollection,
    Value: RandomAccessCollection,
    Value.Element: Identifiable {
}
#endif
