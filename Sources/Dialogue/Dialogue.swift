import Foundation
import SwiftUI

#if canImport(UIKit)
public typealias NativeImage = UIImage
public typealias NativeColor = UIColor
#elseif canImport(AppKit)
public typealias NativeImage = NSImage
public typealias NativeColor = NSColor
#endif

// MARK: -- Protocols

// ## Comparable

/// Clamps the output of a value between a minimum and maximum value.
///
/// ## Example:
/// ```swift
/// let currentExp = 187
/// let expBar = clamp(0, 100) { currentExp }
///
/// print(expBar) // Returns 100
/// ```
public func clamp<T: Comparable>(
    _ floor: T,
    _ ceiling: T,
    _ value: () -> T
) -> T {
    return min(max(value(), floor), ceiling)
}

// ## Collection

public extension Collection {
    /// Conforms any collection into an `Array`.
    ///
    /// Designed for types that normally don't conform into easy collections,
    /// such as `SubSequence` or `ArraySlice`.
    ///
    /// # Example
    /// ```swift
    /// @State private var infiniteScroll: Bool = false
    ///
    /// func filterItems(_ arr: [Item]) -> [Item] {
    ///     return arr.filter { $0.in_stock == false }
    /// }
    ///
    /// let allItems: [Item] = user.items
    /// let firstPageItems: ArraySlice<Item> = allItems[0...9]
    ///
    /// var firstPageResults: [Item] {
    ///     if infiniteScroll {
    ///         return filterItems(allItems)
    ///     }
    ///     else {
    ///         return filterItems(firstPageItems.array)
    ///         // No type mismatch, returns as [Item]
    ///     }
    /// }
    /// ```
    var array: [Element] {
        return Array(self)
    }
}

// ## Codable

public extension Encodable {
    /// Saves an encodable object to a URL. Supports "soft-throwing" errors.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let itemsURL: URL
    ///
    /// // Turn all of this...
    /// do {
    ///     let data = try JSONEncoder().encode(allItems)
    ///     try data.write(to: itemsURL)
    /// }
    /// catch {
    ///     print(error)
    /// }
    ///
    /// // ...into just this!
    /// allItems.save(toURL: itemsURL) { error in print(error) }
    ///
    /// ```
    func save(toURL url: URL, _ throwing: (Error) -> Void) {
        do {
            let encoded = try JSONEncoder().encode(self)
            try encoded.write(to: url)
        }
        catch {
            throwing(error)
        }
    }
    
    /// Saves an encodable object to a URL.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let itemsURL: URL
    ///
    /// try allItems.save(toURL: itemsURL)
    ///
    /// ```
    func save(toURL url: URL) throws {
        let encoded = try JSONEncoder().encode(self)
        try encoded.write(to: url)
    }
    
    /// Saves an encodable object as a value of a UserDefaults key. Supports "soft-throwing" errors.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    ///
    /// allItems.save(toUserDefaultsKey: "items") { error in print(error) }
    ///
    /// ```
    func save(toUserDefaultsKey userDefaultsKey: String, _ throwing: (Error) -> Void) {
        do {
            let encoded = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
        catch {
            throwing(error)
        }
    }
    
    /// Saves an encodable object as a value of a UserDefaults key.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    ///
    /// try allItems.save(toUserDefaultsKey: "items")
    /// ```
    func save(toUserDefaultsKey userDefaultsKey: String) throws {
        let encoded = try JSONEncoder().encode(self)
        UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
    }
}

func test(_ url: URL) throws -> String? {
    url.load(String.self) { error in }
}

public extension URL {
    /// Saves data to the URL. Supports "soft-throwing" errors.
    ///
    /// ## Example
    /// ```swift
    /// @Published var items: [Item] = []
    /// private let itemsURL: URL
    ///
    /// itemsURL.save(items) { error in print(error) }
    /// ```
    func save<T: Encodable>(_ data: T, _ throwing: (Error) -> Void) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: self)
        }
        catch {
            throwing(error)
        }
    }
    
    /// Saves data to the URL.
    ///
    /// ## Example
    /// ```swift
    /// @Published var items: [Item] = []
    /// private let itemsURL: URL
    ///
    /// try itemsURL.save(items)
    /// ```
    func save<T: Encodable>(_ data: T) throws {
        let encoded = try JSONEncoder().encode(data)
        try encoded.write(to: self)
    }
    
    /// Decodes data from a URL. Supports "soft-throwing" errors.
    ///
    /// ## Example
    /// ```swift
    /// @Published var savedItem: Item = // ...
    /// let itemURL: URL
    ///
    /// var item: Item? {
    ///     itemURL.load(Item.self) { error in print(error) }
    /// }
    /// ```
    func load<T: Decodable>(_: T.Type, _ throwing: (Error) -> Void) -> T? {
        do {
            let data = try Data(contentsOf: self)
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            throwing(error)
            return nil
        }
    }
    
    /// Decodes data from a URL.
    ///
    /// ## Example
    /// ```swift
    /// @Published var savedItem: Item = // ...
    /// let itemURL: URL
    ///
    /// let loadedItem = try itemURL.load(Item.self)
    /// ```
    func load<T: Decodable>(_: T.Type) throws -> T {
        let data = try Data(contentsOf: self)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

public extension String {
    /// Saves data to the UserDefaults key. Supports "soft-throwing" errors.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let key: String = "itemData"
    ///
    /// // Instead of this...
    /// do {
    ///     let encoded = try JSONEncoder().encode(data)
    ///     UserDefaults.standard.set(encoded, forKey: key)
    /// }
    /// catch {
    ///     print(error)
    /// }
    ///
    /// // ...do this!
    /// key.save(data) { error in print(error) }
    /// ```
    func save<T: Encodable>(_ data: T, _ throwing: (Error) -> Void) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: self)
        }
        catch {
            throwing(error)
        }
    }
    
    /// Saves data to the UserDefaults key.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let key: String = "itemData"
    ///
    /// // Instead of this...
    /// let encoded = try JSONEncoder().encode(data)
    /// UserDefaults.standard.set(encoded, forKey: key)
    ///
    /// // ...do this!
    /// try key.save(data)
    /// ```
    func save<T: Encodable>(_ data: T) throws {
        let encoded = try JSONEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: self)
    }
    
    /// Decodes data from a UserDefaults key into a desired output. Supports "soft-throwing" errors.
    ///
    /// ## Example
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let key: String = "items"
    ///
    /// key.load(into: allItems) { error in print(error) }
    /// ```
    func load<T: Decodable>(into data: inout T, _ throwing: (Error) -> Void) {
        do {
            if let userDefault = UserDefaults.standard.data(forKey: self) {
                let decoded = try JSONDecoder().decode(T.self, from: userDefault)
                data = decoded
            }
        }
        catch {
            throwing(error)
        }
    }
    
    /// Decodes data from a UserDefaults key into a desired output.
    ///
    /// ## Example
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let key: String = "items"
    ///
    /// try key.load(into: allItems)
    /// ```
    func load<T: Decodable>(into data: inout T) throws {
        if let userDefault = UserDefaults.standard.data(forKey: self) {
            let decoded = try JSONDecoder().decode(T.self, from: userDefault)
            data = decoded
        }
    }
}

public extension Data {
    /// Decodes data into a desired type. Supports "soft-throwing" errors.
    ///
    /// ## Example
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let itemsData = UserDefaults.standard.data(forKey: "items")
    ///
    /// var items: [Item]? {
    ///     itemsData.load([Item].self) { error in print(error }
    /// }
    ///
    /// ```
    func load<T: Decodable>(_: T.Type, _ throwing: (Error) -> Void) -> T? {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: self)
            return decoded
        }
        catch {
            throwing(error)
            return nil
        }
    }
    
    /// Decodes data into a desired type.
    ///
    /// ## Example
    /// ```swift
    /// @Published var allItems: [Item] = // ...
    /// private let itemsData = UserDefaults.standard.data(forKey: "items")
    ///
    /// try itemsData.load([Item].self)
    /// ```
    func load<T: Decodable>(_: T.Type) throws -> T {
        let decoded = try JSONDecoder().decode(T.self, from: self)
        return decoded
    }
}
