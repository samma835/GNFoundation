//
//  BoolExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Bool {
    
    /// GNFoundation: Return 1 if true, or 0 if false.
    ///
    ///        false.gn_int -> 0
    ///        true.gn_int -> 1
    ///
    var gn_int: Int {
        return self ? 1 : 0
    }
    
    /// GNFoundation: Return "true" if true, or "false" if false.
    ///
    ///        false.gn_string -> "false"
    ///        true.gn_string -> "true"
    ///
    var gn_string: String {
        return description
    }
    
    /// GNFoundation: Return inversed value of bool.
    ///
    ///        false.gn_toggled -> true
    ///        true.gn_toggled -> false
    ///
    var gn_toggled: Bool {
        return !self
    }
    
    /// GNFoundation: Returns a random boolean value.
    ///
    ///     Bool.gn_random -> true
    ///     Bool.gn_random -> false
    ///
    static var gn_random: Bool {
        return arc4random_uniform(2) == 1
    }
    
}

