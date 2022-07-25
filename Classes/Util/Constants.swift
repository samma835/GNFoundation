////
////  Constants.swift
////  IGAppKit
////
////  Created by Shanhu Ma on 2019/6/19.
////  Copyright © 2019 Shanhu Ma. All rights reserved.
////
//
//import UIKit
//
//// MARK: - 屏幕适配相关
//
///// 判断是否是iPhone X/XS/XR/XS Max
/////
///// - Returns: Bool 判断手机是否是X/XS/XR/XS Max
//func isIPhoneXLater() -> Bool {
//    var isIphoneX: Bool = false
//    if UIDevice.current.userInterfaceIdiom != .phone {
//        return isIphoneX
//    }
//    if #available(iOS 11.0, *) {
//        if let keyWindow = UIWindow.gn_currentWindow {
//            // 根据屏幕底部安全区域是否大于0来判断是否是iPhone X/XS/XR/XS Max
//            if keyWindow.safeAreaInsets.bottom > 0.0 {
//                isIphoneX = true
//            }
//        }
//    }
//    return isIphoneX
//}
//
///// 获取状态栏高度
/////
///// - Returns: CGFloat statusBarHeight
//func getStatusBarHeight() -> CGFloat {
//    if isIPhoneXLater() {
//        return 44.0
//    } else {
//        return 20.0
//    }
//}
//
///// 返回顶部安全区域的高度 导航栏的高度 + 状态栏高度
/////
///// - Returns: CGFloat 返回顶部安全区域高度
//func getSafeAreaTopHeight() -> CGFloat {
//    if isIPhoneXLater() {
//        return 88.0
//    } else {
//        return 64.0
//    }
//}
//
///// 获取底部安全区域高度
/////
///// - Returns: CGFloat 返回底部安全区域高度
//func getSafeAreaBottomHeight() -> CGFloat {
//    if isIPhoneXLater() {
//        return 34.0
//    } else {
//        return 0
//    }
//}
//
//
///// 等比例缩放物理尺寸
/////
///// - Parameter value: 物理宽度
///// - Returns: 设备中真实的物理宽度
//public func FitRatio(_ value: CGFloat) -> CGFloat {
//    return UIScreen.main.bounds.width * value / 375.0
//}
//
///// 判断手机是否是iPhone X/XS/XR/XS Max
//public let isIPhoneX = isIPhoneXLater()
//
///// 导航栏高度 + 状态栏高度
//public let Nav_H = getSafeAreaTopHeight()
//
///// 获取状态栏高度
//public let Status_H = getStatusBarHeight()
//
///// 获取底部安全区域高度
//public let SafeBottom_H = getSafeAreaBottomHeight()
//
///// 屏幕宽度
//public let ScreenWidth = UIScreen.main.bounds.width
//
///// 屏幕高度
//public let ScreenHeight = UIScreen.main.bounds.height
