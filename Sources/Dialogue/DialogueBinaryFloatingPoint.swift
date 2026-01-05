import Foundation
import SwiftUI

public extension BinaryFloatingPoint {
    /// Translates an integer into a roman numeral.
    ///
    /// ## Example:
    /// ```swift
    /// print(123.roman) // Returns "CXXIII"
    /// ```
    var roman: String {
        guard self > 0 else { return "N" }
        
        let map: [(Int, String)] = [
            (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
            (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"),
            (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
        ]
        
        var number = Int(self)
        var output = ""
        
        for (value, numeral) in map {
            while number >= value {
                output += numeral
                number -= value
            }
        }
        
        return output
    }
    
    /// Represents an amount of seconds in the form of HH:mm:ss.
    ///
    /// ## Parameters:
    /// - `dynamic`: A boolean value indicating if the output is shortened. Set to `true` by default.
    ///
    /// ## Example:
    /// ```swift
    /// let time = 581
    ///
    /// print(time.hhmmss()) // Returns "9:41"
    /// print(time.hhmmss(dynamic: false)) // Returns "00:09:41"
    /// ```
    func hhmmss(dynamic: Bool = true) -> String {
        let hours = Int(self / 3600)
        let hoursString = String(format: "%02d", hours)
        let minutes = Int(self / 60) % 60
        let minutesSingle = String(minutes)
        let minutesString = String(format: "%02d", minutes)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let secondsString = String(format: "%02d", seconds)
        
        let zeroHours: Bool = hours == 0
        let zeroMinutes: Bool = minutes == 0 || (self / 60).truncatingRemainder(dividingBy: 60) == 0
        
        if dynamic {
            switch (zeroHours, zeroMinutes) {
            case (false, _): return "\(hours):\(minutesString):\(secondsString)"
            case (true, _): return "\(minutesSingle):\(secondsString)"
            }
        }
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
}
