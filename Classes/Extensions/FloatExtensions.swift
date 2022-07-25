//
//  FloatExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Float {
    
    /// FDFoundation: Int.
    var gn_int: Int {
        return Int(self)
    }
    
    /// FDFoundation: Double.
    var gn_double: Double {
        return Double(self)
    }
    
    /// FDFoundation: CGFloat.
    var gn_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}
