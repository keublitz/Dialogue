# Dialogue

A collection of SwiftUI macros, designed for organizing and reformatting data without sacrificing legibility.

<p>
  <a href="https://swift.org/"><img src="https://img.shields.io/badge/Swift-6.2-orange.svg" alt="Swift 6.2"></a>
  <a href=""><img src="https://img.shields.io/badge/iOS-14.0-blue.svg" alt="iOS 14.0"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
</p>

---
## Structs

## ```Array```

### ```chunked(into:)```
Divides an array into sub-arrays based on a given integer value.

```swift
let array: [Int] = [1, 2, 3, 4, 5, 6]
print(array.chunked(into: 2)) // Returns [[1, 2, 3], [4, 5, 6]]
print(array.chunked(into: 3)) // Returns [[1, 2], [3, 4], [5, 6]]
```

### ```unique```
Returns the unique elements of an array.

```swift
let genres: [String] = ["drama", "comedy", "horror", "drama", "horror", "musical"]
print(genres.unique) // Returns ["drama", "comedy", "horror", "musical"
```

## ```BinaryInteger``` and ```BinaryFloatingPoint```

### ```roman```
Translates an integer into roman numeral format.

### ```hhmmss(dynamic:)```
Represent an amount of seconds in the HH:mm:ss format.

<b>Parameters</b>
* ```dynamic:``` A boolean value indicating if the output is shortened. Set to TRUE by default.

```swift
let time = 581
print(time.hhmmss()) // Returns "9:41"
print(time.hhmmss(dynamic: false)) // Returns "00:09:41"
```

## ```Color```

### ```hex```
Returns the hexidecimal value of a color.

### ```init?(hex:)```
Returns the color of a hexidecimal value.
> This always returns as an optional ```Color```.

## ```Date```

### ```formatted(_:)```
Returns a given date in a specified format as a string.

### ```year```
Returns the year of a given date.

## ```String```

### ```neutral```

Outputs a non-diacritic, lowercased, article-less version of the string value.
```swift
var songNames = [
    "Zebra Pattern",
    "The Best of the Best",
    "Apple of My Eye",
    "untitled",
    "Èl Camino",
]

print(songNames.sorted{ $0.neutral < $1.neutral })
// ["Apple of My Eye", "The Best of the Best", "Él Camino", "untitled", "Zebra Pattern"]
```

### ```plural(of:es:unique:)```
Pluralizes text based on an integer value.

<b>Parameters</b>
* ```of```: The integer whose value decides whether or not the string is pluralized.
* ```es```: A boolean value indicating whether or not the word is pluralized with an "es" at the end. Set to FALSE by default.
* ```unique```: An optional string value for unique pluralizations.

```swift
var pizzaCount: Int = 3
var sandwichCount: Int = 4

var pizzas: String = "\(pizzaCount) pizza".plural(of: pizzaCount)
var sandwiches: String = "\(sandwichCount) sandwich".plural(of: sandwichCount, es: true)

print("\(pizzas) and \(sandwiches) ordered")
// Returns "3 pizzas and 4 sandwiches ordered"
```
```swift
var userCount: Int = 67

var onlineUsers: String = "\(onlineUserCount) person".plural(of: userCount, unique: "people")

print("\(onlineUsers) are online")
// Returns "67 people are online"
```

### ```intoDate```
Translates a string in any valid date format to a date.

### ```year```
Returns the year of a given string date, if the string is in a valid date format.

## ``UIImage``

### ```blurred(_:)```
Adds a radial blur to an image.

### ```pixelate(_:)```
Adds a pixelated filter to an image.

### ```crop(from:_:)```
Crops an image from a given direction.

---

## Protocols

## ```Comparable```

### ```clamp(_:_:_:)```
Clamps the output of a value between a minimum and maximum value.

```swift
let currentExp = 187
let expBar = clamp(0, 100) { currentExp }

print(expBar) // Returns 100
```

## License
Dialogue is available under the MIT license. See the LICENSE file for more info.
