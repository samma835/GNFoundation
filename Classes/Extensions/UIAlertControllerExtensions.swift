//
//  UIAlertControllerExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import UIKit
import AudioToolbox

// MARK: - Methods
public extension UIAlertController {
    
    /// GNFoundation: Present alert view controller in the current view controller.
    ///
    /// - Parameters:
    ///   - animated: set true to animate presentation of alert controller (default is true).
    ///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
    ///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
    func gn_show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        if vibrate {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    /// GNFoundation: Add an action to Alert
    ///
    /// - Parameters:
    ///   - title: action title
    ///   - style: action style (default is UIAlertActionStyle.default)
    ///   - isEnabled: isEnabled status for action (default is true)
    ///   - handler: optional action handler to be called when button is tapped (default is nil)
    /// - Returns: action created by this method
    @discardableResult func gn_addAction(title: String, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
    }
    
    /// GNFoundation: Add a text field to Alert
    ///
    /// - Parameters:
    ///   - text: text field text (default is nil)
    ///   - placeholder: text field placeholder text (default is nil)
    ///   - editingChangedTarget: an optional target for text field's editingChanged
    ///   - editingChangedSelector: an optional selector for text field's editingChanged
    func gn_addTextField(text: String? = nil, placeholder: String? = nil, editingChangedTarget: Any?, editingChangedSelector: Selector?) {
        addTextField { tf in
            tf.text = text
            tf.placeholder = placeholder
            if let target = editingChangedTarget, let selector = editingChangedSelector {
                tf.addTarget(target, action: selector, for: .editingChanged)
            }
        }
    }
    
}

// MARK: - Initializers
public extension UIAlertController {
    
    /// GNFoundation: Create new alert view controller with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title.
    ///   - message: alert controller's message (default is nil).
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(gn_title: String, gn_message: String? = nil, gn_defaultActionButtonTitle: String = "OK", gn_tintColor: UIColor? = nil) {
        self.init(title: gn_title, message: gn_message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: gn_defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = gn_tintColor {
            view.tintColor = color
        }
    }
    
    /// GNFoundation: Create new error alert view controller from Error with default OK action.
    ///
    /// - Parameters:
    ///   - title: alert controller's title (default is "Error").
    ///   - error: error to set alert controller's message to it's localizedDescription.
    ///   - defaultActionButtonTitle: default action button title (default is "OK")
    ///   - tintColor: alert controller's tint color (default is nil)
    convenience init(gn_title: String = "Error", gn_error: Error, gn_defaultActionButtonTitle: String = "OK", gn_preferredStyle: UIAlertController.Style = .alert, gn_tintColor: UIColor? = nil) {
        self.init(title: gn_title, message: gn_error.localizedDescription, preferredStyle: gn_preferredStyle)
        let defaultAction = UIAlertAction(title: gn_defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = gn_tintColor {
            view.tintColor = color
        }
    }
    
}



