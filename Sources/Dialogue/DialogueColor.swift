import Foundation
import SwiftUI

public extension Color {
    /// Returns the hexadecimal value of a color.
    ///
    /// ## Example:
    /// ```swift
    /// var purple: Color = .purple
    /// let hex = purple.hex
    ///
    /// print(hex) // Returns "#A020F0"
    /// ```
    var hex: String {
        guard let components = NativeColor(self).cgColor.components else { return "#000000" }
        
        let r = Int((components[0]) * 255.0)
        let g = Int((components[1]) * 255.0)
        let b = Int((components[2]) * 255.0)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    /// Returns the color of a hexadecimal value.
    ///
    /// > Note: This always returns as an optional.
    ///
    /// ## Example:
    /// ```swift
    /// let purpleHex: String = "#A020F0"
    /// let purple = Color(hex: purpleHex) ?? .clear
    ///
    /// Text("Grape juice")
    ///     .foregroundStyle(purple)
    /// ```
    init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: formattedHex).scanHexInt64(&rgb) else { return nil }
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

fileprivate typealias ColorValues = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

// Gets the red, green, blue and alpha values from a NativeColor.
fileprivate func getValues(of color: NativeColor) -> ColorValues {
    var rgba: ColorValues = (0,0,0,0)
    
    color.getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
    
    return rgba
}

// Returns true if euclidean distance of two colors surpass a given threshold.
fileprivate func visibleDifference(
    _ lhs: ColorValues,
    _ rhs: ColorValues,
    threshold: CGFloat
) -> Bool {
    let distance: CGFloat = sqrt(
        pow(lhs.red - rhs.red, 2) +
        pow(lhs.green - rhs.green, 2) +
        pow(lhs.blue - rhs.blue, 2)
    )
    
    let maxDistance: CGFloat = sqrt(3 * pow(255,2))
    let similarity: CGFloat = 1 - (distance / maxDistance)
    
    return similarity >= threshold
}

/// Returns `true` if the range of two colors exceeds a given threshold.
///
/// ## Parameters:
/// - `of`: The threshold the range must exceed, expressed as a percentage. Defaults to 0.4 (40%).
/// - `x`: The starting color.
/// - `y`: The ending color.
public func gradientHasWideRange(
    of threshold: CGFloat = 0.4,
    _ x: Color,
    _ y: Color
) -> Bool {
    let uiX = NativeColor(x)
    let uiY = NativeColor(y)
    
    let lhs = getValues(of: uiX)
    let rhs = getValues(of: uiY)
    
    if visibleDifference(lhs, rhs, threshold: threshold) {
        return true
    }
    
    return false
}

/// Returns a color from the middle of a gradient.
///
/// ## Parameters:
/// - `percent`: The distance within the gradient to pull the color from,
/// expressed as a percentage. Defaults to 0.5.
/// - `from`: The starting color.
/// - `to`: The ending color.
///
/// ## Example:
/// ```swift
/// let middle = middleColor(from: .red, to: .yellow)
///
/// Text("This is the middle color.")
///     .foregroundStyle(middle) // Returns orange
/// ```
public func middleColor(
    percent origin: Double = 0.5,
    from x: Color,
    to y: Color
) -> Color {
    guard origin >= 0 && origin <= 1 else { return x }
    
    let start = NativeColor(x)
    let end = NativeColor(y)
    
    let lhs = getValues(of: start)
    let rhs = getValues(of: end)
    
    let r = lhs.red + (rhs.red - lhs.red) * origin
    let g = lhs.green + (rhs.green - lhs.green) * origin
    let b = lhs.blue + (rhs.blue - lhs.blue) * origin
    
    return Color(red: r, green: g, blue: b)
}
