import Foundation
import SwiftUI

public enum DateFormat {
    /// Displays full name of month with day and year.
    case full
    /// Displays abbreviated name of month with day and year.
    case short
    /// Displays full name of month with year
    case monthYear
    /// Displays abbreviated name of month with year.
    case shortMonthYear
    /// Displays year only.
    case year
}

public extension Date {
    /// Returns a date in a specified format.
    func formatted(_ format: DateFormat = .full) -> String {
        var dateFormat: String {
            switch format {
            case .full: return "MMMM d, yyyy"
            case .short: return "MMM. d, yyyy"
            case .monthYear: return "MMMM yyyy"
            case .shortMonthYear: return "MMM. yyyy"
            case .year: return "yyyy"
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    /// Returns the year of a given date.
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}

