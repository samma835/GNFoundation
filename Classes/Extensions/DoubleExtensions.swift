//
//  DoubleExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension Double {
    
    /// FDFoundation: Int.
    var gn_int: Int {
        return Int(self)
    }
    
    /// FDFoundation: Float.
    var gn_float: Float {
        return Float(self)
    }
    
    /// FDFoundation: CGFloat.
    var gn_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}
