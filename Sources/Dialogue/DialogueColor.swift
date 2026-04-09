import Foundation
import SwiftUI

#if os(macOS)
@available(macOS 11.0, *)
#endif
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
    @available(*, deprecated, message: "This extension has been moved to the [JunkDrawer](https://github.com/keublitz/JunkDrawer) package, which includes this extension as part of a codable color class. Please migrate to this package.")
    var deprecated_hex: String {
        guard let components = NativeColor(self).cgColor.components else {
            assertionFailure("Color has no components — unexpected color space.")
            return "#000000"
        }
        
        let r = Int((components[0] * 255.0).rounded()) & 0xFF
        let g = Int((components[1] * 255.0).rounded()) & 0xFF
        let b = Int((components[2] * 255.0).rounded()) & 0xFF
        let a = Int((components[3] * 255.0).rounded()) & 0xFF
        
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
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
    @available(*, deprecated, message: "This extension has been moved to the [JunkDrawer](https://github.com/keublitz/JunkDrawer) package, which includes this extension as part of a codable color class. Please migrate to this package.")
    init?(deprecated_hex: String) {
        var formattedHex = deprecated_hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: formattedHex).scanHexInt64(&rgb) else { return nil }
        
        if formattedHex.count == 8 {
            let r = CGFloat((rgb >> 24) & 0xFF) / 255.0
            let g = CGFloat((rgb >> 16) & 0xFF) / 255.0
            let b = CGFloat((rgb >> 8) & 0xFF) / 255.0
            let a = CGFloat(rgb & 0xFF) / 255.0
            
            self.init(red: r, green: g, blue: b, opacity: a)
        }
        else {
            let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            let b = CGFloat(rgb & 0xFF) / 255.0
            
            self.init(red: r, green: g, blue: b)
        }
    }
}

#if os(iOS)
public extension UIColor {
    /// Returns the hexadecimal value of a color.
    ///
    /// ## Example:
    /// ```swift
    /// var purple: UIColor = .purple
    /// let hex = purple.hex
    ///
    /// print(hex) // Returns "#A020F0FF"
    /// ```
    @available(*, deprecated, message: "This extension has been moved to the [JunkDrawer](https://github.com/keublitz/JunkDrawer) package, which includes this extension as part of a codable color class. Please migrate to this package.")
    var deprecated_hex: String {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let rgbaColor = self.cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil),
              let components = rgbaColor.components,
              components.count >= 4 else {
            assertionFailure("Color has no components — unexpected color space.")
            return "#000000"
        }
        
        let r = Int((components[0]) * 255.0)
        let g = Int((components[1]) * 255.0)
        let b = Int((components[2]) * 255.0)
        let a = Int((components[3]) * 255.0)
        
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
    
    /// Returns the color of a hexadecimal value.
    ///
    /// > Note: This always returns as an optional.
    ///
    /// ## Example:
    /// ```swift
    /// let purpleHex: String = "#A020F0FF"
    /// let purple = UIColor(hex: purpleHex) ?? .clear
    ///
    /// Text("Grape juice")
    ///     .foregroundStyle(purple)
    /// ```
    @available(*, deprecated, message: "This extension has been moved to the [JunkDrawer](https://github.com/keublitz/JunkDrawer) package, which includes this extension as part of a codable color class. Please migrate to this package.")
    convenience init?(deprecated_hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = deprecated_hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: formattedHex).scanHexInt64(&rgb) else { return nil }
        
        if formattedHex.count == 8 {
            let r = CGFloat((rgb >> 24) & 0xFF) / 255.0
            let g = CGFloat((rgb >> 16) & 0xFF) / 255.0
            let b = CGFloat((rgb >> 8) & 0xFF) / 255.0
            let a = CGFloat(rgb & 0xFF) / 255.0
            
            self.init(red: r, green: g, blue: b, alpha: a)
        }
        else {
            let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            let b = CGFloat(rgb & 0xFF) / 255.0
            
            self.init(red: r, green: g, blue: b, alpha: alpha)
        }
    }
    
    /// Returns the SwiftUI equivalent of the color.
    @available(*, deprecated, message: "This extension has been moved to the [JunkDrawer](https://github.com/keublitz/JunkDrawer) package, which includes this extension as part of a codable color class. Please migrate to this package.")
    var deprecated_color: Color {
        var rVal: CGFloat = 0
        var bVal: CGFloat = 0
        var gVal: CGFloat = 0
        var aVal: CGFloat = 0
        
        guard getRed(&rVal, green: &gVal, blue: &bVal, alpha: &aVal) else {
            return .clear
        }
        
        return Color(
            red: rVal,
            green: gVal,
            blue: bVal)
        .opacity(aVal)
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
#endif

