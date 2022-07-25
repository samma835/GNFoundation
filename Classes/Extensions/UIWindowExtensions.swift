//
//  UIWindowExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import UIKit

public typealias GNWindow = UIWindow

// MARK: - Properties
public extension GNWindow {
    
    /// GNFoundation: Find current window ,returns the current window.
    static var gn_currentWindow: UIWindow? {
        let enumerator = UIApplication.shared.windows.reversed()
        for window in enumerator {
            let windowOnMainScreen = (window.screen == UIScreen.main)
            let windowIsVisible = (!window.isHidden && window.alpha > 0)
            if windowOnMainScreen && windowIsVisible && window.isKeyWindow {
                return window
            }
        }
        return UIApplication.shared.delegate?.window ?? nil
    }
}
