//
//  UIColorExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import UIKit

public typealias GNColor = UIColor

// MARK: - Initializers
public extension GNColor {
    
    /// GNFoundation: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(gn_red: Int, gn_green: Int, gn_blue: Int, gn_transparency: CGFloat = 1) {
        guard gn_red >= 0 && gn_red <= 255 else { return nil }
        guard gn_green >= 0 && gn_green <= 255 else { return nil }
        guard gn_blue >= 0 && gn_blue <= 255 else { return nil }
        
        var trans = gn_transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(gn_red) / 255.0, green: CGFloat(gn_green) / 255.0, blue: CGFloat(gn_blue) / 255.0, alpha: trans)
    }
    
    /// GNFoundation: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(gn_hex: Int, gn_transparency: CGFloat = 1) {
        var trans = gn_transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (gn_hex >> 16) & 0xff
        let green = (gn_hex >> 8) & 0xff
        let blue = gn_hex & 0xff
        self.init(gn_red: red, gn_green: green, gn_blue: blue, gn_transparency: trans)
    }
    
    /// GNFoundation: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    convenience init?(gn_hexString: String, gn_transparency: CGFloat = 1) {
        var string = ""
        if gn_hexString.lowercased().hasPrefix("0x") {
            string =  gn_hexString.replacingOccurrences(of: "0x", with: "")
        } else if gn_hexString.hasPrefix("#") {
            string = gn_hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = gn_hexString
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        
        var trans = gn_transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(gn_red: red, gn_green: green, gn_blue: blue, gn_transparency: trans)
    }
    
    /// GNFoundation: Create Color from a complementary of a Color (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(gn_complementaryFor color: GNColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: GNColor) -> GNColor?) = { color -> GNColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = GNColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }
        
        let c = convertColorToRGBSpace(color)
        guard let componentColors = c?.cgColor.components else { return nil }
        
        let r: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let g: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let b: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}


// MARK: - Properties
public extension GNColor {
    
    /// GNFoundation: Random color.
    static var gn_random: GNColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return GNColor(gn_red: r, gn_green: g, gn_blue: b)!
    }
    
    /// GNFoundation: RGB components for a Color (between 0 and 255).
    ///
    ///        UIColor.red.gn_rgbComponents.red -> 255
    ///        NSColor.green.gn_rgbComponents.green -> 255
    ///        UIColor.blue.gn_rgbComponents.blue -> 255
    ///
    var gn_rgbComponents: (red: Int, green: Int, blue: Int) {
        var components: [CGFloat] {
            let c = cgColor.components!
            if c.count == 4 {
                return c
            }
            return [c[0], c[0], c[0], c[1]]
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return (red: Int(r * 255.0), green: Int(g * 255.0), blue: Int(b * 255.0))
    }
    
    /// GNFoundation: RGB components for a Color represented as CGFloat numbers (between 0 and 1)
    ///
    ///        UIColor.red.gn_rgbComponents.red -> 1.0
    ///        NSColor.green.gn_rgbComponents.green -> 1.0
    ///        UIColor.blue.gn_rgbComponents.blue -> 1.0
    ///
    var gn_cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var components: [CGFloat] {
            let c = cgColor.components!
            if c.count == 4 {
                return c
            }
            return [c[0], c[0], c[0], c[1]]
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return (red: r, green: g, blue: b)
    }
    
    /// GNFoundation: Get components of hue, saturation, and brightness, and alpha (read-only).
    var gn_hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /// GNFoundation: Hexadecimal value string (read-only).
    var gn_hexString: String {
        let components: [Int] = {
            let c = cgColor.components!
            let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
    
    /// GNFoundation: Short hexadecimal value string (read-only, if applicable).
    var gn_shortHexString: String? {
        let string = gn_hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }
    
    /// GNFoundation: Short hexadecimal value string, or full hexadecimal string if not possible (read-only).
    var gn_shortHexOrHexString: String {
        let components: [Int] = {
            let c = cgColor.components!
            let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
            return components.map { Int($0 * 255.0) }
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }
    
    /// GNFoundation: Alpha of Color (read-only).
    var gn_alpha: CGFloat {
        return cgColor.alpha
    }
    
    /// GNFoundation: CoreImage.CIColor (read-only)
    var gn_coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)
    }
    
    /// GNFoundation: Get UInt representation of a Color (read-only).
    var gn_uInt: UInt {
        let c: [CGFloat] = {
            let c = cgColor.components!
            return c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
        }()
        
        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(c[0] * 255.0) << 16
        colorAsUInt32 += UInt32(c[1] * 255.0) << 8
        colorAsUInt32 += UInt32(c[2] * 255.0)
        
        return UInt(colorAsUInt32)
    }
    
    /// GNFoundation: Get color complementary (read-only, if applicable).
    var gn_complementary: GNColor? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: GNColor) -> GNColor?) = { color -> GNColor? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = GNColor(cgColor: colorRef!)
                return colorOut
            } else {
                return self
            }
        }
        
        let c = convertColorToRGBSpace(self)
        guard let componentColors = c?.cgColor.components else { return nil }
        
        let r: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let g: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let b: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        
        return GNColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}


// MARK: - Methods
public extension GNColor {
    
    /// GNFoundation: Blend two Colors
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and seond colors.
    static func gn_blend(_ color1: GNColor, intensity1: CGFloat = 0.5, with color2: GNColor, intensity2: CGFloat = 0.5) -> GNColor {
        // http://stackoverflow.com/questions/27342715/blend-uicolors-in-swift
        
        let total = intensity1 + intensity2
        let level1 = intensity1/total
        let level2 = intensity2/total
        
        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }
        
        let components1: [CGFloat] = {
            let c = color1.cgColor.components!
            return c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
        }()
        let components2: [CGFloat] = {
            let c = color2.cgColor.components!
            return c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
        }()
        
        let r1 = components1[0]
        let r2 = components2[0]
        
        let g1 = components1[1]
        let g2 = components2[1]
        
        let b1 = components1[2]
        let b2 = components2[2]
        
        let a1 = color1.cgColor.alpha
        let a2 = color2.cgColor.alpha
        
        let r = level1*r1 + level2*r2
        let g = level1*g1 + level2*g2
        let b = level1*b1 + level2*b2
        let a = level1*a1 + level2*a2
        
        return GNColor(red: r, green: g, blue: b, alpha: a)
        
    }
    
    /// GNFoundation: Lighten a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let lighterColor: Color = color.gn_lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color
    /// - Returns: A lightened color
    func gn_lighten(by percentage: CGFloat = 0.2) -> GNColor {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return GNColor(red: min(r + percentage, 1.0),
                       green: min(g + percentage, 1.0),
                       blue: min(b + percentage, 1.0),
                       alpha: a)
    }
    
    /// GNFoundation: Darken a color
    ///
    ///     let color = Color(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: Color = color.gn_darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color
    /// - Returns: A darkened color
    func gn_darken(by percentage: CGFloat = 0.2) -> GNColor {
        // https://stackoverflow.com/questions/38435308/swift-get-lighter-and-darker-color-variations-for-a-given-uicolor
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return GNColor(red: max(r - percentage, 0),
                       green: max(g - percentage, 0),
                       blue: max(b - percentage, 0),
                       alpha: a)
    }
}

// 16进制颜色转换

/**
 MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
 UnableToScanHexValue:      "Scan hex error"
 MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
 */
public enum UIColorInputError : Error {
    case missingHashMarkAsPrefix,
    unableToScanHexValue,
    mismatchedHexStringLength
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
    
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.
     
     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.
     
     - parameter hex4: Four-digit hexadecimal value.
     */
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
     
     - parameter hex8: Eight-digit hexadecimal value.
     */
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
     
     - parameter rgba: String value.
     */
    public convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.missingHashMarkAsPrefix
        }
        
        /*
         Examples In Swift 3, 4:
         
         let newStr = str.substring(to: index) // Swift 3
         let newStr = String(str[..<index]) // Swift 4
         
         let newStr = str.substring(from: index) // Swift 3
         let newStr = String(str[index...]) // Swift 4
         
         let range = firstIndex..<secondIndex // If you have a range
         let newStr = = str.substring(with: range) // Swift 3
         let newStr = String(str[range])  // Swift 4
         
         See more here - https://developer.apple.com/documentation/swift/substring.
         */
        #if swift(>=4.0)
        let hexString = String(rgba[rgba.index(rgba.startIndex, offsetBy: 1)...])
        #else
        let hexString: String = rgba.substring(from: rgba.characters.index(rgba.startIndex, offsetBy: 1))
        #endif
        
        var hexValue:  UInt32 = 0
        
        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            throw UIColorInputError.unableToScanHexValue
        }
        
        switch (hexString.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        case 8:
            self.init(hex8: hexValue)
        default:
            throw UIColorInputError.mismatchedHexStringLength
        }
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.
     
     - parameter rgba: String value.
     */
    public convenience init(_ rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
    
    /**
     Hex string of a UIColor instance.
     
     - parameter includeAlpha: Whether the alpha should be included.
     */
    public func hexString(_ includeAlpha: Bool = true) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}
