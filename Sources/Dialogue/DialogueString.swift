import Foundation
import SwiftUI

public extension String {
    /// Outputs a non-diacritic, lowercased, article-less version of the string.
    ///
    /// In addition to neutralizing letter differences, all instances of numbers within the string are converted into their word equivalent.
    /// ## Example
    /// ```swift
    /// let songNames = [
    ///     "Zebra Pattern"
    ///     "The Best of the Best",
    ///     "Apple of My Eye",
    ///     "8 Years Ago",
    ///     "untitled",
    ///     "Èl Camino",
    /// ]
    ///
    /// print(songNames.sorted{ $0.neutral < $1.neutral })
    /// // Returns ["Apple of My Eye", "The Best of the Best", "8 Years Ago", "Èl Camino", "untitled", "Zebra Pattern"]
    /// ```
    var neutral: String {
        return self.neutralModifiers()
    }
    
    /// Outputs a non-diacritic, lowercased, article-less version of the string.
    ///
    /// ## Parameters
    /// - `keepArticles`: When `true`, articles will not be removed from the string.
    /// - `alphabetizeNumerals`: When `true`, numerals will be changed into their word form.
    ///
    /// ## Example
    /// ```swift
    /// let songNames = [
    ///     "Zebra Pattern"
    ///     "The Best of the Best",
    ///     "Apple of My Eye",
    ///     "8 Years Ago",
    ///     "untitled",
    ///     "Èl Camino",
    /// ]
    ///
    /// print(songNames.sorted{ $0.neutral < $1.neutral })
    /// // Returns ["Apple of My Eye", "The Best of the Best", "8 Years Ago", "Èl Camino", "untitled", "Zebra Pattern"]
    /// ```
    func neutral(keepArticles: Bool = false, alphabetizeNumerals: Bool = true) -> String {
        return self.neutralModifiers(keepArticles: keepArticles, alphabetizeNumerals: alphabetizeNumerals)
    }
    
    private var articlesDropped: String {
        let lowerCasedTitle = self.lowercased()
        
        let articles = ["a ", "an ", "the "]
        
        for article in articles {
            if lowerCasedTitle.hasPrefix(article) {
                return String(self.dropFirst(article.count))
            }
        }
        
        return self
    }
    
    private func neutralModifiers(keepArticles: Bool = false, alphabetizeNumerals: Bool = true) -> String {
        var str = self
        
        if !keepArticles {
            str = str.articlesDropped
        }
        
        str = str
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "\'", with: "")
            
        let mutStr = NSMutableString(string: str)
        
        if alphabetizeNumerals {
            let pattern = #"\d+"#
            guard let regex = try? NSRegularExpression(pattern: pattern) else { return str }
            
            let matches = regex.matches(in: str, range: NSRange(location: 0, length: str.utf16.count))
            
            for match in matches.reversed() {
                let matchString = (str as NSString).substring(with: match.range)
                if let number = Int(matchString) {
                    mutStr.replaceCharacters(in: match.range, with: number.word)
                }
            }
        }
        
        return mutStr as String
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
    /// let pizzas: String = "\(pizzaCount) pizza".plural(of: pizzaCount)
    /// let sandwiches: String = "\(sandwichCount) sandwich".plural(of: sandwichCount, es: true)
    ///
    /// print("\(pizzas) and \(sandwiches) ordered")
    /// // Returns "3 pizzas and 4 sandwiches ordered"
    ///
    /// ```
    /// ```swift
    /// var userCount: Int = 67
    ///
    /// let onlineUsers: String = "\(onlineUserCount) person".plural(of: userCount, unique: "people")
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

fileprivate let lastNamePrefixes: [String] = [
    // spanish/portuguese
    "de", "del", "dos", "das",
    // french
    "du", "des", "le", "la",
    // dutch/flemish
    "van", "den", "der", "te", "ter", "ten",
    // german
    "von", "vom", "zu", "zum", "zur",
    // italian
    "di", "della", "degli", "delle", "da",
    // arabic
    "bin", "ibn", "bint",
    // misc.
    "af", "av", "ap"
]

fileprivate func extractLastName(from name: String) -> String {
    let suffixes = ["Jr.", "Sr.", "II", "III", "IV", "V"]
    let components = name.components(separatedBy: " ").filter { !$0.isEmpty }
    
    if components.count > 1 {
        for i in (0..<components.count).reversed() {
            if lastNamePrefixes.contains(components[i].lowercased()),
               i + 1 < components.count {
                return components[i] + " " + components[components.endIndex - 1]
            }
        }
    }
    
    guard !components.isEmpty else { return "" }
    
    let lastWord = components.last ?? ""
    let hasSuffix = suffixes.contains(lastWord)
    
    if hasSuffix && components.count > 2 {
        return components[components.count - 2]
            .replacingOccurrences(of: ",", with: "")
    }
    else {
        return lastWord
    }
}

public extension Array where Element == String {
    /// Sorts an array of names in alphabetical order of last name.
    ///
    /// # Example
    /// ```swift
    /// let credits: [String] = [
    ///     "Robert De Niro",
    ///     "Joe Pesci",
    ///     "Ray Liotta",
    ///     "Frank Vincent"
    /// ]
    ///
    /// print(credits.sortedByLastName)
    /// // ["Robert De Niro", "Ray Liotta", "Joe Pesci", "Frank Vincent"]
    /// ```
    var sortedByLastName: [String] {
        let sorted = self.sorted {
            let lhs = extractLastName(from: $0.neutral)
            let rhs = extractLastName(from: $1.neutral)
            
            return lhs < rhs
        }
        
        return sorted
    }
}
