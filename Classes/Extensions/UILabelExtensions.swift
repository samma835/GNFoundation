//
//  UILabelExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import UIKit

public typealias GNLabel = UILabel

// MARK: - Properties
public extension GNLabel {
    
    /// GNFoundation: Required height for a label
    var gn_requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}


// MARK: - Methods
public extension GNLabel {
    
    /// GNFoundation: Sets a custom font from a character at an index to character at another index.
    ///
    /// - Parameters:
    ///   - font: New font to be setted.
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    func gn_setFont(_ font: GNFont, fromIndex: Int, toIndex: Int) {
        guard let text = self.text else {
            return
        }
        
        self.attributedText = text.gn_attributedString.gn_font(font, range: NSRange(location: fromIndex, length: toIndex - fromIndex))
    }
    
    /// GNFoundation: Sets a custom font from a character at an index to character at another index.
    ///
    /// - Parameters:
    ///   - font: New font to be setted.
    ///   - fontSize: New font size.
    ///   - fromIndex: The start index.
    ///   - toIndex: The end index.
    func gn_setFont(_ font: GNFontName, fontSize: CGFloat, fromIndex: Int, toIndex: Int) {
        guard let text = self.text else {
            return
        }
        
        self.attributedText = text.gn_attributedString.gn_font(GNFont(gn_fontName: font, gn_size: fontSize), range: NSRange(location: fromIndex, length: toIndex - fromIndex))
    }
    
    
    /// GNFoundation
    func gn_getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }
    
    /// GNFoundation
    func gn_getEstimatedHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: gn_width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    /// GNFoundation
    func gn_getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: gn_height)).width
    }
    
    /// GNFoundation
    func gn_fitHeight() {
        self.gn_height = gn_getEstimatedHeight()
    }
    
    /// GNFoundation
    func gn_fitWidth() {
        self.gn_width = gn_getEstimatedWidth()
    }
    
    /// GNFoundation
    func gn_fitSize() {
        self.gn_fitWidth()
        self.gn_fitHeight()
        sizeToFit()
    }
    
    /// GNFoundation (if duration set to 0 animate wont be)
    func gn_set(text _text: String?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = _text
        }, completion: nil)
    }
    
}


// MARK: - Initializers
public extension GNLabel {
    
    /// GNFoundation: Initialize a UILabel with text
    convenience init(gn_text: String?) {
        self.init()
        self.text = gn_text
    }
    
    /// GNFoundation: Create an UILabel with the given parameters.
    ///
    /// - Parameters:
    ///   - frame: Label frame.
    ///   - text: Label text.
    ///   - font: Label font.
    ///   - color: Label text color.
    ///   - alignment: Label text alignment.
    ///   - lines: Label text lines.
    ///   - shadowColor: Label text shadow color.
    convenience init(gn_frame: CGRect, gn_text: String, gn_font: UIFont, gn_color: UIColor = .black, gn_alignment: NSTextAlignment = .left, gn_lines: Int, gn_shadowColor: UIColor = UIColor.clear) {
        self.init(frame: gn_frame)
        self.font = gn_font
        self.text = gn_text
        self.backgroundColor = UIColor.clear
        self.textColor = gn_color
        self.textAlignment = gn_alignment
        self.numberOfLines = gn_lines
        self.shadowColor = gn_shadowColor
    }
    
    /// GNFoundation: Create an UILabel with the given parameters.
    ///
    /// - Parameters:
    ///   - frame: Label frame.
    ///   - text: Label text.
    ///   - font: Label font name.
    ///   - size: Label font size.
    ///   - color: Label text color.
    ///   - alignment: Label text alignment.
    ///   - lines: Label text lines.
    ///   - shadowColor: Label text shadow color.
    convenience init(gn_frame: CGRect, gn_text: String, gn_font: GNFontName, gn_fontSize: CGFloat, gn_color: UIColor = .black, gn_alignment: NSTextAlignment = .left, gn_lines: Int, gn_shadowColor: UIColor = UIColor.clear) {
        self.init(frame: gn_frame)
        self.font = GNFont(gn_fontName: gn_font, gn_size: gn_fontSize)
        self.text = gn_text
        self.backgroundColor = UIColor.clear
        self.textColor = gn_color
        self.textAlignment = gn_alignment
        self.numberOfLines = gn_lines
        self.shadowColor = gn_shadowColor
    }
}



