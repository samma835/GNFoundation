//
//  StringExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension String {
    
    /// GNFoundation: Convert a String to a NSAttributedString.
    /// With that variable you can customize a String with a style.
    ///
    ///     string.gn_attributedString.font(UIFont(fontName: .helveticaNeue, size: 20))
    ///
    ///     You can even concatenate two or more styles:
    ///
    ///     string.gn_attributedString.font(UIFont(fontName: .helveticaNeue, size: 20)).backgroundColor(UIColor.red)
    ///
    var gn_attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// GNFoundation: String decoded from base64 (if applicable).
    ///
    ///        "SGVsbG8gV29ybGQh".gn_base64Decoded = Optional("Hello World!")
    ///
    var gn_base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// GNFoundation: String encoded in base64 (if applicable).
    ///
    ///        "Hello World!".gn_base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var gn_base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// GNFoundation: Array of characters of a string.
    ///
    var gn_charactersArray: [Character] {
        return Array(self)
    }
    
    /// GNFoundation: CamelCase of string.
    ///
    ///        "sOme vAriable naMe".gn_camelCased -> "someVariableName"
    ///
    var gn_camelCased: String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    
    /// GNFoundation: Returns the lenght of the string.
    var gn_length: Int {
        return self.count
    }
    
    /// GNFoundation: Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var gn_containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// GNFoundation: First character of string (if applicable).
    ///
    ///        "Hello".gn_firstCharacterAsString -> Optional("H")
    ///        "".gn_firstCharacterAsString -> nil
    ///
    var gn_firstCharacterAsString: String? {
        guard let first = self.first else { return nil }
        return String(first)
    }
    
    /// GNFoundation: Check if string contains one or more letters.
    ///
    ///        "123abc".gn_hasLetters -> true
    ///        "123".gn_hasLetters -> false
    ///
    var gn_hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// GNFoundation: Check if string contains one or more numbers.
    ///
    ///        "abcd".gn_hasNumbers -> false
    ///        "123abc".gn_hasNumbers -> true
    ///
    var gn_hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// GNFoundation: Check if string contains only letters.
    ///
    ///        "abc".gn_isAlphabetic -> true
    ///        "123abc".gn_isAlphabetic -> false
    ///
    var gn_isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    /// GNFoundation: Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".gn_isAlphaNumeric -> true
    ///        "abc".gn_isAlphaNumeric -> false
    ///
    var gn_isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// GNFoundation: Check if string is valid email format.
    ///
    ///        "john@doe.com".gn_isEmail -> true
    ///
    var gn_isEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return gn_matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    
    /// GNFoundation: Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func gn_matches(pattern: String) -> Bool {
        return range(of: pattern,
                     options: String.CompareOptions.regularExpression,
                     range: nil, locale: nil) != nil
    }
    
    
    /// GNFoundation: Check if string is a valid URL.
    ///
    ///        "https://google.com".gn_isValidUrl -> true
    ///
    var gn_isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /// GNFoundation: Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".gn_isValidSchemedUrl -> true
    ///        "google.com".gn_isValidSchemedUrl -> false
    ///
    var gn_isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    
    /// GNFoundation: Check if string is a valid https URL.
    ///
    ///        "https://google.com".gn_isValidHttpsUrl -> true
    ///
    var gn_isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    
    /// GNFoundation: Check if string is a valid http URL.
    ///
    ///        "http://google.com".gn_isValidHttpUrl -> true
    ///
    var gn_isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    
    /// GNFoundation: Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".gn_isValidFileUrl -> true
    ///
    var gn_isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    /// GNFoundation: Check if string is a valid Swift number.
    ///
    /// Note:
    /// In North America, "." is the decimal separator,
    /// while in many parts of Europe "," is used,
    ///
    ///        "123".gn_isNumeric -> true
    ///     "1.3".gn_isNumeric -> true (en_US)
    ///     "1,3".gn_isNumeric -> true (fr_FR)
    ///        "abc".gn_isNumeric -> false
    ///
    var gn_isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    /// GNFoundation: Check if string only contains digits.
    ///
    ///     "123".gn_isDigits -> true
    ///     "1.3".gn_isDigits -> false
    ///     "abc".gn_isDigits -> false
    ///
    var gn_isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    /// GNFoundation: Last character of string (if applicable).
    ///
    ///        "Hello".gn_lastCharacterAsString -> Optional("o")
    ///        "".gn_lastCharacterAsString -> nil
    ///
    var gn_lastCharacterAsString: String? {
        guard let last = self.last else { return nil }
        return String(last)
    }
    
    /// GNFoundation: Latinized string.
    ///
    ///        "Hèllö Wórld!".gn_latinized -> "Hello World!"
    ///
    var gn_latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    /// GNFoundation: Bool value from string (if applicable).
    ///
    ///        "1".gn_bool -> true
    ///        "False".gn_bool -> false
    ///        "Hello".gn_bool = nil
    ///
    var gn_bool: Bool? {
        let selfLowercased = gn_trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    /// GNFoundation: Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".gn_date -> Optional(Date)
    ///
    var gn_date: Date? {
        let selfLowercased = gn_trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    /// GNFoundation: Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///        "2007-06-29 14:23:09".gn_dateTime -> Optional(Date)
    ///
    var gn_dateTime: Date? {
        let selfLowercased = gn_trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    
    /// GNFoundation: Integer value from string (if applicable).
    ///
    ///        "101".gn_int -> 101
    ///
    var gn_int: Int? {
        return Int(self)
    }
    
    
    /// GNFoundation: URL from string (if applicable).
    ///
    ///        "https://google.com".gn_url -> URL(string: "https://google.com")
    ///        "not url".gn_url -> nil
    ///
    var gn_url: URL? {
        return URL(string: self)
    }
    
    /// GNFoundation: String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".gn_trimmed -> "hello"
    ///
    var gn_trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// GNFoundation: Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".gn_urlDecoded -> "it's easy to decode strings"
    ///
    var gn_urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// GNFoundation: URL escaped string.
    ///
    ///        "it's easy to encode strings".gn_urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var gn_urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /// GNFoundation: String without spaces and new lines.
    ///
    ///        "   \n GN   \n  Foundation  ".gn_withoutSpacesAndNewLines -> "GNFoundation"
    ///
    var gn_withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /// GNFoundation: Check if the given string contains only white spaces
    var gn_isWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Methods
public extension String {
    
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func gn_float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Float
    }
    
    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func gn_double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Double
    }
    
    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    func gn_cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    
    /// GNFoundation: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".gn_localized -> Hallo Welt
    ///
    func gn_localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// GNFoundation: The most common character in string.
    ///
    ///        "This is a test, since e is appearing everywhere e should be the common character".gn_mostCommonCharacter() -> "e"
    ///
    /// - Returns: The most common character.
    func gn_mostCommonCharacter() -> Character? {
        let mostCommon = gn_withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
            }.max { $0.1 < $1.1 }?.0
        
        return mostCommon
    }
    
    /// GNFoundation: Array with unicodes for all characters in a string.
    ///
    ///        "GNFoundation".gn_unicodeArray -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: The unicodes for all characters in a string.
    func gn_unicodeArray() -> [Int] {
        return unicodeScalars.map({ $0.hashValue })
    }
    
    /// GNFoundation: an array of all words in a string
    ///
    ///        "Swift is amazing".gn_words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func gn_words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    /// GNFoundation: Count of words in a string.
    ///
    ///        "Swift is amazing".gn_wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func gn_wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        return gn_words().count
    }
    
    /// GNFoundation: Transforms the string into a slug string.
    ///
    ///        "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: The string in slug format.
    func gn_toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.gn_latinized
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")
        
        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }
        
        while filtered.gn_lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }
        
        while filtered.gn_firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }
        
        return filtered.replacingOccurrences(of: "--", with: "-")
    }
    
    /// GNFoundation: Safely subscript string with index.
    ///
    ///        "Hello World!"[3] -> "l"
    ///        "Hello World!"[20] -> nil
    ///
    /// - Parameter i: index.
    subscript(gn_safe i: Int) -> Character? {
        guard i >= 0 && i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
    
    /// GNFoundation: Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[6..<11] -> "World"
    ///        "Hello World!"[21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(gn_safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    
    /// GNFoundation: Copy string to global pasteboard.
    ///
    ///        "SomeText".gn_copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func gn_copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
    
    /// GNFoundation: Converts string format to CamelCase.
    ///
    ///        var str = "sOme vaRiabLe Name"
    ///        str.camelize()
    ///        print(str) // prints "someVariableName"
    ///
    mutating func gn_camelize() {
        self = gn_camelCased
    }
    
    
    /// GNFoundation: Check if string ends with substring.
    ///
    ///        "Hello World!".gn_ends(with: "!") -> true
    ///        "Hello World!".gn_ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func gn_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// GNFoundation: Latinize string.
    ///
    ///        var str = "Hèllö Wórld!"
    ///        str.gn_latinize()
    ///        print(str) // prints "Hello World!"
    ///
    mutating func gn_latinize() {
        self = gn_latinized
    }
    
    /// GNFoundation: Random string of given length.
    ///
    ///        String.gn_random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func gn_random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            let randomIndex = arc4random_uniform(UInt32(base.count))
            let randomCharacter = base.gn_charactersArray[Int(randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
    
    /// GNFoundation: Reverse string.
    mutating func gn_reverse() {
        let chars: [Character] = reversed()
        self = String(chars)
    }
    
    /// GNFoundation: Sliced string from a start index with length.
    ///
    ///        "Hello World".gn_slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func gn_slicing(from i: Int, length: Int) -> String? {
        guard length >= 0, i >= 0, i < count  else { return nil }
        guard i.advanced(by: length) <= count else {
            return self[gn_safe: i..<count]
        }
        guard length > 0 else { return "" }
        return self[gn_safe: i..<i.advanced(by: length)]
    }
    
    /// GNFoundation: Slice given string from a start index with length (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    mutating func gn_slice(from i: Int, length: Int) {
        if let str = self.gn_slicing(from: i, length: length) {
            self = String(str)
        }
    }
    
    /// GNFoundation: Slice given string from a start index to an end index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.gn_slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    mutating func gn_slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        if let str = self[gn_safe: start..<end] {
            self = str
        }
    }
    
    /// GNFoundation: Slice given string from a start index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.gn_slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter i: string index the slicing should start from.
    mutating func gn_slice(at i: Int) {
        guard i < count else { return }
        if let str = self[gn_safe: i..<count] {
            self = str
        }
    }
    
    /// GNFoundation: Check if string starts with substring.
    ///
    ///        "hello World".gn_starts(with: "h") -> true
    ///        "hello World".gn_starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func gn_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// GNFoundation: Date object from string of date format.
    ///
    ///        "2017-01-15".gn_date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".gn_date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    func gn_date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    /// GNFoundation: Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.gn_trim()
    ///        print(str) // prints "Hello World"
    ///
    mutating func gn_trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// GNFoundation: Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.gn_truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    mutating func gn_truncate(toLength length: Int, trailing: String? = "...") {
        guard length > 0 else { return }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
    }
    
    /// GNFoundation: Convert URL string to readable string.
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.gn_urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    mutating func gn_urlDecode() {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
    }
    
    /// GNFoundation: Escape string.
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.gn_urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    mutating func gn_urlEncode() {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
    }
    
    /// GNFoundation: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".gn_padStart(10) -> "       hue"
    ///   "hue".gn_padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    mutating func gn_padStart(_ length: Int, with string: String = " ") {
        self = gn_paddingStart(length, with: string)
    }
    
    /// GNFoundation: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".gn_paddingStart(10) -> "       hue"
    ///   "hue".gn_paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func gn_paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }
    
    /// GNFoundation: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".gn_padEnd(10) -> "hue       "
    ///   "hue".gn_padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    mutating func gn_padEnd(_ length: Int, with string: String = " ") {
        self = gn_paddingEnd(length, with: string)
    }
    
    /// GNFoundation: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".gn_paddingEnd(10) -> "hue       "
    ///   "hue".gn_paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func gn_paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }
    
}

// MARK: - Operators
public extension String {
    
    /// GNFoundation: Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }
    
    /// GNFoundation: Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
    
}

// MARK: - Initializers
public extension String {
    
    /// GNFoundation: Create a new string from a base64 string (if applicable).
    ///
    ///        String(gn_base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///        String(gn_base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    init?(gn_base64: String) {
        guard let str = gn_base64.gn_base64Decoded else { return nil }
        self.init(str)
    }
    
    /// GNFoundation: Create a new random string of given length.
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    init(gn_randomOfLength length: Int) {
        self = String.gn_random(ofLength: length)
    }
    
}

// MARK: - NSAttributedString extensions
public extension String {
    
    /// GNFoundation: Bold string.
    var gn_bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// GNFoundation: Underlined string
    var gn_underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    /// GNFoundation: Strikethrough string.
    var gn_strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    /// GNFoundation: Italic string.
    var gn_italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// GNFoundation: Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    func gn_colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    
}

// MARK: - NSString extensions
public extension String {
    
    /// GNFoundation: NSString from a string.
    var gn_nsString: NSString {
        return NSString(string: self)
    }
    
    /// GNFoundation: NSString lastPathComponent.
    var gn_lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    /// GNFoundation: NSString pathExtension.
    var gn_pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    /// GNFoundation: NSString deletingLastPathComponent.
    var gn_deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    /// GNFoundation: NSString deletingPathExtension.
    var gn_deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    /// GNFoundation: NSString pathComponents.
    var gn_pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    /// GNFoundation: NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func gn_appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    /// GNFoundation: NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    func gn_appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
}

// MARK: - MD5 Declaration

/// GNFoundation: array of bytes, little-endian representation
func gn_arrayOfBytes<T>(value:T, length:Int? = nil) -> [UInt8] {
    let totalBytes = length ?? MemoryLayout<T>.size
    
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value
    
    let bytesPointer = UnsafeMutablePointer<UInt8>(OpaquePointer(valuePointer))
    var bytes = Array<UInt8>(repeating: 0, count: totalBytes)
    for j in 0..<min(MemoryLayout<T>.size,totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
    }
    /*
     See more in
     https://github.com/apple/swift-evolution/blob/master/proposals/0184-unsafe-pointers-add-missing.md
     
     */
    #if swift(>=4.1)
    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()
    #else
    valuePointer.deinitialize()
    valuePointer.deallocate(capacity: 1)
    #endif
    return bytes
}

struct GNBytesSequence: Sequence {
    let chunkSize: Int
    let data: [UInt8]
    
    func makeIterator() -> AnyIterator<ArraySlice<UInt8>> {
        var offset:Int = 0
        return AnyIterator {
            let end = Swift.min(self.chunkSize, self.data.count - offset)
            let result = self.data[offset..<offset + end]
            offset += result.count
            return !result.isEmpty ? result : nil
        }
    }
}

class GNHashBase {
    
    static let size:Int = 16 // 128 / 8
    let message: [UInt8]
    
    init (_ message: [UInt8]) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    func prepare(_ len:Int) -> [UInt8] {
        var tmpMessage = message
        
        // Step 1. Append Padding Bits
        tmpMessage.append(0x80) // append one bit (UInt8 with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.count
        var counter = 0
        
        while msgLength % len != (len - 8) {
            counter += 1
            msgLength += 1
        }
        
        tmpMessage += Array<UInt8>(repeating: 0, count: counter)
        return tmpMessage
    }
}

func gn_rotateLeft(v: UInt32, n: UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func gn_sliceToUInt32Array(_ slice: ArraySlice<UInt8>) -> [UInt32] {
    var result = [UInt32]()
    result.reserveCapacity(16)
    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: MemoryLayout<UInt32>.size) {
        let val1:UInt32 = (UInt32(slice[idx.advanced(by: 3)]) << 24)
        let val2:UInt32 = (UInt32(slice[idx.advanced(by: 2)]) << 16)
        let val3:UInt32 = (UInt32(slice[idx.advanced(by: 1)]) << 8)
        let val4:UInt32 = UInt32(slice[idx])
        let val:UInt32 = val1 | val2 | val3 | val4
        result.append(val)
    }
    return result
}

class GNMD5: GNHashBase {
    
    /** specifies the per-round shift amounts */
    private let s: [UInt32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
                               5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
                               4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
                               6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]
    
    /** binary integer part of the sines of integers (Radians) */
    private let k: [UInt32] = [0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,
                               0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
                               0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,
                               0x6b901122,0xfd987193,0xa679438e,0x49b40821,
                               0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,
                               0xd62f105d,0x2441453,0xd8a1e681,0xe7d3fbc8,
                               0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,
                               0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
                               0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,
                               0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
                               0x289b7ec6,0xeaa127fa,0xd4ef3085,0x4881d05,
                               0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
                               0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,
                               0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
                               0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,
                               0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391]
    
    private let h: [UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    
    func calculate() -> [UInt8] {
        var tmpMessage = prepare(64)
        tmpMessage.reserveCapacity(tmpMessage.count + 4)
        
        // initialize hh with hash values
        var hh = h
        
        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits = (message.count * 8)
        let lengthBytes = lengthInBits.gn_bytes(totalBytes: 64 / 8)
        tmpMessage += lengthBytes.reversed()
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        for chunk in GNBytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            var M = gn_sliceToUInt32Array(chunk)
            assert(M.count == 16, "Invalid array")
            
            // Initialize hash value for this chunk:
            var A:UInt32 = hh[0]
            var B:UInt32 = hh[1]
            var C:UInt32 = hh[2]
            var D:UInt32 = hh[3]
            
            var dTemp:UInt32 = 0
            
            // Main loop
            for j in 0..<k.count {
                var g = 0
                var F:UInt32 = 0
                
                switch (j) {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ gn_rotateLeft(v: A &+ F &+ k[j] &+ M[g], n: s[j])
                A = dTemp
            }
            
            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }
        
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        
        hh.forEach {
            let itemLE = $0.littleEndian
            result += [UInt8(itemLE & 0xff), UInt8((itemLE >> 8) & 0xff), UInt8((itemLE >> 16) & 0xff), UInt8((itemLE >> 24) & 0xff)]
        }
        
        return result
    }
}

// MARK: - Encryption
public extension String {
    
    /// MD5 string value from string .
    ///
    /// - Returns: MD5 string.
    func gn_md5() -> String {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return self
        }
        
        let MD5Calculator = GNMD5(Array(data))
        let MD5Data = MD5Calculator.calculate()
        let resultBytes = UnsafeMutablePointer<CUnsignedChar>(mutating: MD5Data)
        let resultEnumerator = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: MD5Data.count)
        let MD5String = NSMutableString()
        for c in resultEnumerator {
            MD5String.appendFormat("%02x", c)
        }
        return MD5String as String
    }
    
}

public extension String {
    
    /// A dictionary of parameters to apply to a `URLRequest`.
    typealias GNParameters = [String: Any]
    
    /// 单独百分比编码参数的 value
    ///
    /// - Parameter value: value
    /// - Returns: 编码后的字符串
    /// - Throws: An `Error` if the encoding process encounters an error.
    static func gn_percentEncode(value: Any, usingPercentEncoding: Bool = true) throws -> String {
        var resultString = ""
        
        if let dictionary = value as? GNParameters{
            if let v = gn_jsonToStr(dictionary as AnyObject) {
                resultString = v
            } else {
                assert(false, " value json to string faild")
            }
        } else if let array = value as? [Any] {
            if let v = gn_jsonToStr(array as AnyObject) {
                resultString = v
            } else {
                assert(false, " value json to string faild")
            }
        }  else if let number = value as? NSNumber {
            if number.isBool {
                resultString = gn_boolEncode(value: number.boolValue)
            } else {
                resultString = "\(number)"
            }
        } else if let bool = value as? Bool {
            resultString = gn_boolEncode(value: bool)
        } else {
            resultString = "\(value)"
        }
        
        if usingPercentEncoding {
            resultString = gn_escape(resultString)
        }
        
        return resultString
    }
    
    /// 将参数字典转换成queryString，["A":"aaa", "B":"bbb"] -> "A=aaa&B=bbb"
    ///
    /// - Parameter params: 参数字典
    /// - Returns: 参数字符串 for url
    static func gn_percentQuery(_ params: GNParameters) -> String {
        var components: [(String, String)] = []
        
        for key in params.keys.sorted(by: <){
            if let value = params[key]{
                components += gn_queryComponents(fromKey: key, value: value)
            }
        }
        return components.map{"\($0)=\($1)"}.joined(separator: "&")
    }
    
    
    /// 解析键值对，转换为"%"编码的 url query string components
    /// "B": ["C": "ccc"] -> [(B, "C"), (B, "ccc")]
    /// ["A": ["B": ["ccc", "ddd"]]] -> [(A, "{"B":["ccc","ddd"]}")]
    ///
    /// - Parameters:
    ///   - key
    ///   - value
    /// - Returns: %编码的 url query string components
    private static func gn_queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? GNParameters{
            if let v = gn_jsonToStr(dictionary as AnyObject) {
                components.append((gn_escape(key), gn_escape(v)))
            } else {
                assert(false, " queryComponents's parameter json to string faild")
            }
        } else if let array = value as? [Any] {
            if let v = gn_jsonToStr(array as AnyObject) {
                components.append((gn_escape(key), gn_escape(v)))
            } else {
                assert(false, " queryComponents's parameter json to string faild")
            }
        }  else if let number = value as? NSNumber {
            if number.isBool {
                components.append((gn_escape(key), gn_escape(gn_boolEncode(value: number.boolValue))))
            } else {
                components.append((gn_escape(key), gn_escape("\(number)")))
            }
        } else if let bool = value as? Bool {
            components.append((gn_escape(key), gn_escape(gn_boolEncode(value: bool))))
        } else {
            components.append((gn_escape(key), gn_escape("\(value)")))
        }
        
        return components
    }
    
    
    /// 将字符串转换成遵循 RFC 3986 的"%编码"字符串
    ///
    /// RFC 3986 规定了以下字符为保留字
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// 在 RFC 3986 - Section 3.4 中规定, 为了使 query strings 可以包含一个 URL ，其中的"?" 和 "/" 不应该被转换成 "%编码"。
    /// 因此，除了 "?" 和 "/" 之外的所有保留字都需要转换成 "%编码"。
    ///
    /// - parameter string: 待转换字符串
    ///
    /// - returns: %编码
    private static func gn_escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  在 iOS 8.1 和 8.2 中 addingPercentEncoding 在处理数百个中文汉字字符会报内存错误。这里用 batchSize 限定一次处理的字符量来规避这个问题。
        //  具体信息见:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    /// JSON to string
    private static func gn_jsonToStr(_ json: AnyObject) -> String? {
        
        if (json as? String) != nil {
            return json as? String
        }
        
        if !JSONSerialization.isValidJSONObject(json) {
            return nil
        }
        
        do {
            let data =  try JSONSerialization.data(withJSONObject: json)
            var result = String(data: data, encoding: String.Encoding.utf8)
            result = result?.replacingOccurrences(of: "\\/", with: "/") // JSONSerialization 会把 / 转义为 \\/
            return result
        } catch let JSONError {
            assert(false, "error:" + "\(JSONError)")
        }
        
        return nil
    }
    
    /// 布尔值编码
    ///
    /// - Parameter value: Bool
    /// - Returns: string
    private static func gn_boolEncode(value: Bool) -> String {
        return value ? "true" : "false"
    }
}

fileprivate extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
