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
