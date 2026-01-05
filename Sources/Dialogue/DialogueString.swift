import Foundation
import SwiftUI

public extension String {
    /// Outputs a non-diacritic, lowercased, article-less version of the string.
    ///
    /// ## Example
    /// ```swift
    /// var songNames = [
    ///     "Zebra Pattern"
    ///     "The Best of the Best",
    ///     "Apple of My Eye",
    ///     "untitled",
    ///     "Èl Camino",
    /// ]
    ///
    /// print(songNames.sorted{ $0.neutral < $1.neutral })
    /// // Returns ["Apple of My Eye", "The Best of the Best", "Èl Camino", "untitled", "Zebra Pattern"]
    /// ```
    var neutral: String {
        let lowerCasedTitle = self.lowercased()
        
        let articles = ["a ", "an ", "the ", "i "]
        
        for article in articles {
            if lowerCasedTitle.hasPrefix(article) {
                return String(self.dropFirst(article.count))
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .lowercased()
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "\'", with: "")
            }
        }
        
        return self
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "\'", with: "")
    }
    
    /// Pluralizes text based on an integer value.
    ///
    /// ## Parameters
    /// - `of`: The integer whose value decides whether or not the string is pluralized.
    /// - `es`: A boolean value indicating whether or not the word is pluralized with an "es" at the end. Set to FALSE by default.
    /// - `unique`: An optional string value for unique pluralizations.
    ///
    /// ## Example:
    /// ```swift
    /// var pizzaCount: Int = 3
    /// var sandwichCount: Int = 4
    ///
    /// var pizzas: String = "\(pizzaCount) pizza".plural(of: pizzaCount)
    /// var sandwiches: String = "\(sandwichCount) sandwich".plural(of: sandwichCount, es: true)
    ///
    /// print("\(pizzas) and \(sandwiches) ordered")
    /// // Returns "3 pizzas and 4 sandwiches ordered"
    ///
    /// ```
    /// ```swift
    /// var userCount: Int = 67
    ///
    /// var onlineUsers: String = "\(onlineUserCount) person".plural(of: userCount, unique: "people")
    ///
    /// print("\(onlineUsers) are online")
    /// // Returns "67 people are online"
    ///
    /// ```
    func plural(of count: Int, es: Bool = false, unique: String? = nil) -> String {
        if count == 1 { return self } else {
            if let unique { return unique }
            
            if es == true {
                return self + "es"
            }
            return self + "s"
        }
    }
    
    /// Translates a string in any valid date format to a date.
    var intoDate: Date? {
        let fullFormats: [String] = [
            "MMddyy",
            "MM/dd/yy",
            "MMddyyyy",
            "MM dd yyyy",
            "MM dd, yyyy",
            "MM/dd/yyyy",
            "dd MM yyyy",
            "yyyyMMdd",
            "yyyy/MM/dd",
        ]
        
        let yearMonthFormats: [String] = [
            "MM/yy",
            "MM/yyyy",
            "yy/MM",
            "yyyy/MM",
        ]
        
        let justYear: String = "yyyy"
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = justYear
        if let date = formatter.date(from: self) {
            return date
        }
        
        for format in yearMonthFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
            continue
        }
        
        for format in fullFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
            continue
        }
        
        return nil
    }
    
    /// Returns the year of a given string, if the string is in a valid date format.
    var year: Int? {
        if let date = self.intoDate {
            return Calendar.current.component(.year, from: date)
        }
        
        return nil
    }
}
