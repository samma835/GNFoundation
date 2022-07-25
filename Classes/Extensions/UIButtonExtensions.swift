//
//  UIButtonExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension UIButton {
    
    /// GNFoundation: Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var gn_imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }
    
    /// GNFoundation: Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var gn_imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }
    
    /// GNFoundation: Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable var gn_imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// GNFoundation: Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable var gn_imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
    /// GNFoundation: Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
    
    /// GNFoundation: Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    /// GNFoundation: Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    /// GNFoundation: Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }
    
    /// GNFoundation: Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    /// GNFoundation: Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    /// GNFoundation: Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// GNFoundation: Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable var gn_titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
    
}

// MARK: - Methods
public extension UIButton {
    
    private var gn_states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    /// GNFoundation: Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func gn_setImageForAllStates(_ image: UIImage) {
        gn_states.forEach { self.setImage(image, for: $0) }
    }
    
    /// GNFoundation: Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func gn_setTitleColorForAllStates(_ color: UIColor) {
        gn_states.forEach { self.setTitleColor(color, for: $0) }
    }
    
    /// GNFoundation: Set title for all states.
    ///
    /// - Parameter title: title string.
    func gn_setTitleForAllStates(_ title: String) {
        gn_states.forEach { self.setTitle(title, for: $0) }
    }
    
    /// GNFoundation: Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    func gn_centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    /// GNFoundation: set button gradient colors
    ///
    /// - Parameters:
    ///   - startPoint: startPoint position CGPoint 0..1
    ///   - endPoint: endPoint position CGPoint 0..1
    ///   - colors: gradient colors array
    func gn_gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        
        var gradientLayer: CAGradientLayer!
        
        gn_removeGradientLayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        self.layer.masksToBounds = false
    }

    /// GNFoundation: the gradientcolors
    func gn_removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

public extension UIButton {
    
    // 枚举图片的位置
    enum ButtonImageEdgeInsetsStyle: Int {
        case top       // 上图下文字
        case left      // 左图右文字
        case bottom    // 下图上文字
        case right     // 右图左文字
    }
    
    // MARK: 设置图片文字方向距离
    func layoutButtonImageEdgeInsetsStyle(style: ButtonImageEdgeInsetsStyle, space: CGFloat) {
        let imageWidth: CGFloat = (self.imageView?.frame.size.width)!
        let imageHeight: CGFloat = (self.imageView?.frame.size.height)!
        
        var labelWidth: CGFloat = 0
        var labelHeight: CGFloat = 0
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        var imageEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space / 2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth+space / 2.0)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
