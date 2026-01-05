import Foundation
import SwiftUI

public extension Array {
    /// Divides an array into sub-arrays based on a given integer value.
    ///
    /// ## Example:
    /// ```swift
    /// let array: [Int] = [1, 2, 3, 4, 5, 6]
    ///
    /// print(array.chunked(into: 2)) // Returns [[1, 2, 3], [4, 5, 6]]
    /// print(array.chunked(into: 3)) // Returns [[1, 2], [3, 4], [5, 6]]
    ///
    /// ```
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public extension Array where Element: Equatable {
    /// Returns only the unique elements of an array.
    ///
    /// ## Example:
    /// ```swift
    /// let genres: [String] = ["drama", "comedy", "horror", "drama", "horror", "musical"]
    /// print(genres.unique) // Returns ["drama", "comedy", "horror", "musical"
    ///
    /// ```
    var unique: [Element] {
        var result: [Element] = []
        for item in self {
            if !result.contains(item) {
                result.append(item)
            }
        }
        return result
    }
}
