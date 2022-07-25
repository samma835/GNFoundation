//
//  SignedIntegerExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension SignedInteger {
    
    /// GNFoundation: Absolute value of integer number.
    var gn_abs: Self {
        return Swift.abs(self)
    }
    
    /// GNFoundation: Check if integer is positive.
    var gn_isPositive: Bool {
        return self > 0
    }
    
    /// GNFoundation: Check if integer is negative.
    var gn_isNegative: Bool {
        return self < 0
    }
    
    /// GNFoundation: Check if integer is even.
    var gn_isEven: Bool {
        return (self % 2) == 0
    }
    
    /// GNFoundation: Check if integer is odd.
    var gn_isOdd: Bool {
        return (self % 2) != 0
    }
    
    /// GNFoundation: String of format (XXh XXm) from seconds Int.
    var gn_timeString: String {
        guard self > 0 else {
            return "0 s"
        }
        if self < 60 {
            return "\(self) s"
        }
        if self < 3600 {
            return "\(self / 60) m"
        }
        let hours = self / 3600
        let mins = (self % 3600) / 60
        
        if hours != 0 && mins == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(mins)m"
    }
    
}

