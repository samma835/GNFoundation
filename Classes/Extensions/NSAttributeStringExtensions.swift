//
//  NSAttributeStringExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension NSAttributedString {
    
    /// GNFoundation: Bolded string.
    var gn_bolded: NSAttributedString {
        return gn_applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// GNFoundation: Underlined string.
    var gn_underlined: NSAttributedString {
        return gn_applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    #if os(iOS)
    /// GNFoundation: Italicized string.
    var gn_italicized: NSAttributedString {
        return gn_applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    /// GNFoundation: Struckthrough string.
    var gn_struckthrough: NSAttributedString {
        return gn_applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    
    /// GNFoundation: Dictionary of the attributes applied across the whole string
    var gn_attributes_p: [NSAttributedString.Key: Any] {
        return attributes(at: 0, effectiveRange: nil)
    }
    
}

// MARK: - Methods
public extension NSAttributedString {
    
    /// GNFoundation: Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func gn_applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        
        return copy
    }
    
    /// GNFoundation: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func gn_colored(with color: UIColor) -> NSAttributedString {
        return gn_applying(attributes: [.foregroundColor: color])
    }
    
    /// GNFoundation: Apply attributes to substrings matching a regular expression
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    func gn_applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        
        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }
        return result
    }
    
    /// GNFoundation: Apply attributes to occurrences of a given string
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    func gn_applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        
        return gn_applying(attributes: attributes, toRangesMatching: pattern)
    }
    
    /// GNFoundation: UIFont or NSFont, default Helvetica(Neue) 12.
    ///
    /// - Parameters:
    ///   - font: UIFont or NSFont, default Helvetica(Neue) 12.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_font(_ font: GNFont, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: NSParagraphStyle, default defaultParagraphStyle
    ///
    /// - Parameters:
    ///   - paragraphStyle: NSParagraphStyle, default defaultParagraphStyle
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_paragraphStyle(_ paragraphStyle: NSParagraphStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: UIColor or NSColor, default black.
    ///
    /// - Parameters:
    ///   - foregroundColor: UIColor or NSColor, default black.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_foregroundColor(_ foregroundColor: GNColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: foregroundColor, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: UIColor or NSColor, default nil means no background.
    ///
    /// - Parameters:
    ///   - backgroundColor: UIColor or NSColor, default nil means no background.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_backgroundColor(_ backgroundColor: GNColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: backgroundColor, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Default true means default ligatures, false means no ligatures.
    ///
    /// - Parameters:
    ///   - ligature: Default true means default ligatures, false means no ligatures.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_ligature(_ ligature: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.ligature, value: ligature, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Amount to modify default kerning.
    /// 0 means kerning is disabled.
    ///
    /// - Parameters:
    ///   - kern: Amount to modify default kerning.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_kern(_ kern: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.kern, value: kern, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Default 0 means no strikethrough.
    ///
    /// - Parameters:
    ///   - strikethroughStyle: Default 0 means no strikethrough.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_strikethroughStyle(_ strikethroughStyle: Int, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: strikethroughStyle, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: NSUnderlineStyle.
    ///
    /// - Parameters:
    ///   - underlineStyle: NSUnderlineStyle.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_underlineStyle(_ underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: underlineStyle, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strokeColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_strokeColor(_ strokeColor: GNColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeColor, value: strokeColor, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: In percent of font point size, default 0 measn no stroke.
    /// Positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0).
    ///
    /// - Parameters:
    ///   - strokeWidth: In percent of font point size, default 0 measn no stroke.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_strokeWidth(_ strokeWidth: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeWidth, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: NSShadow, default nil means no shadow.
    ///
    /// - Parameters:
    ///   - shadow: NSShadow, default nil means no shadow.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_shadow(_ shadow: NSShadow, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.shadow, value: shadow, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Default nil means no text effect.
    ///
    /// - Parameters:
    ///   - textEffect: Default is nil means no text effect. Currently, only NSTextEffectLetterpressStyle can be used.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_textEffect(_ textEffect: String, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.textEffect, value: textEffect, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: NSTextAttachment, default is nil.
    ///
    /// - Parameters:
    ///   - attachment: NSTextAttachment, default is nil.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_attachment(_ attachment: NSTextAttachment, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.attachment, value: attachment, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: NSURL.
    ///
    /// - Parameters:
    ///   - link: NSURL.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_link(_ link: NSURL, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.link, value: link, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Offset from baseline, default is 0.
    ///
    /// - Parameters:
    ///   - baselineOffset: Offset from baseline, default is 0.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_baselineOffset(_ baselineOffset: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - underlineColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_underlineColor(_ underlineColor: GNColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: UIColor or NSColor, default nil means same as foreground color.
    ///
    /// - Parameters:
    ///   - strikethroughColor: UIColor or NSColor, default nil means same as foreground color.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_strikethroughColor(_ strikethroughColor: GNColor, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: strikethroughColor, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Skew to be applied to glyphs, default 0 means no skew.
    ///
    /// - Parameters:
    ///   - obliqueness: Skew to be applied to glyphs, default 0 means no skew.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_obliqueness(_ obliqueness: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.obliqueness, value: obliqueness, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///
    /// - Parameters:
    ///   - expansion: Log of expansion factor to be applied to glyphs, default 0 means no expansion.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_expansion(_ expansion: Float, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.expansion, value: expansion, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    /// The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.
    /// Remeber to use `.rawValue`, because the attribute wants an Int.
    /// - LRE: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.embedding.
    /// - RLE: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.embedding.
    /// - LRO: NSWritingDirection.leftToRight, NSWritingDirectionFormatType.override.
    /// - RLO: NSWritingDirection.rightToLeft, NSWritingDirectionFormatType.override.
    ///
    /// - Parameters:
    ///   - writingDirection: Array of Int representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_writingDirection(_ writingDirection: [Int], range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.writingDirection, value: writingDirection, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: The value 0 indicates horizontal text, the value 1 indicates vertical text.
    /// In iOS, horizontal text is always used and specifying a different value is undefined.
    ///
    /// - Parameters:
    ///   - verticalGlyphForm: The value false indicates horizontal text, the value true indicates vertical text.
    ///   - range: Application range. Default is all the String.
    /// - Returns: Returns a NSAttributedString.
    func gn_verticalGlyphForm(_ verticalGlyphForm: Bool, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: self.string, attributes: self.gn_attributes())
        mutableAttributedString.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: verticalGlyphForm, range: gn_attributedStringRange(range))
        return mutableAttributedString as NSAttributedString
    }
    
    /// GNFoundation: Set text alignment to left.
    ///
    /// - Returns: Returns a NSAttributedString.
    func gn_textAlignmentLeft() -> NSAttributedString {
        return self.gn_textAlignment(.left)
    }
    
    /// GNFoundation: Set text alignment to right.
    ///
    /// - Returns: Returns a NSAttributedString.
    func gn_textAlignmentRight() -> NSAttributedString {
        return self.gn_textAlignment(.right)
    }
    
    /// GNFoundation: Set text alignment to center.
    ///
    /// - Returns: Returns a NSAttributedString.
    func gn_textAlignmentCenter() -> NSAttributedString {
        return self.gn_textAlignment(.center)
    }
    
    /// GNFoundation: Set text alignment to justified.
    ///
    /// - Returns: Returns a NSAttributedString.
    func gn_textAlignmentJustified() -> NSAttributedString {
        return self.gn_textAlignment(.justified)
    }
    
    /// GNFoundation: Returns a list of all string attributes.
    ///
    /// - Returns: Returns a list of all string attributes.
    func gn_attributes() -> [NSAttributedString.Key: Any] {
        return self.attributes(at: 0, longestEffectiveRange: nil, in: self.gn_attributedStringRange(nil))
    }
    
    /// GNFoundation: Set text alignment.
    ///
    /// - Parameter alignment: Text alignment.
    /// - Returns: Returns an NSAttributedString with the given text alignment.
    private func gn_textAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let textAlignment = NSMutableParagraphStyle()
        textAlignment.alignment = alignment
        
        return self.gn_paragraphStyle(textAlignment)
    }
    
    /// GNFoundation: Returns self NSRange if the given NSRange is nil.
    ///
    /// - Parameter range: Given NSRange.
    /// - Returns: Returns self NSRange if the given NSRange is nil.
    private func gn_attributedStringRange(_ range: NSRange?) -> NSRange {
        return range ?? NSRange(location: 0, length: self.string.gn_length)
    }
    
}




// MARK: - Operators
public extension NSAttributedString {
    
    /// GNFoundation: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }
    
    /// GNFoundation: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }
    
    /// GNFoundation: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    /// GNFoundation: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
}







