//
//  IntExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation


// MARK: - Properties
public extension Int {
    
    /// GNFoundation Array of bytes with optional padding (little-endian)
    func gn_bytes(totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return gn_arrayOfBytes(value: self, length: totalBytes)
    }
    
    /// GNFoundation: CountableRange 0..<Int.
    var gn_countableRange: CountableRange<Int> {
        return 0..<self
    }
    
    /// GNFoundation: Radian value of degree input.
    var gn_degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    /// GNFoundation: Degree value of radian input
    var gn_radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    /// GNFoundation: UInt.
    var gn_uInt: UInt {
        return UInt(self)
    }
    
    /// GNFoundation: Double.
    var gn_double: Double {
        return Double(self)
    }
    
    /// GNFoundation: Float.
    var gn_float: Float {
        return Float(self)
    }
    
    /// GNFoundation: CGFloat.
    var gn_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /// GNFoundation: String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
    var gn_kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0 && abs < 1000 {
            return "0k"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        return String(format: "\(sign)%ikk", abs / 100000)
    }
    
    /// GNFoundation: Array of digits of integer value.
    var gn_digits: [Int] {
        guard self != 0 else { return [0] }
        var digits = [Int]()
        var number = Swift.abs(self)
        
        while number != 0 {
            let x = number % 10
            digits.append(x)
            number = number / 10
        }
        
        digits.reverse()
        return digits
    }
    
    /// GNFoundation: Number of digits of integer value.
    var gn_digitsCount: Int {
        guard self != 0 else { return 1 }
        let number = Double(Swift.abs(self))
        return Int(log10(number) + 1)
    }
    
}
