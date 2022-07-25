//
//  URLRequestExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Initializers
public extension URLRequest {
    
    /// GNFoundation: Create URLRequest from URL string.
    ///
    /// - Parameter urlString: URL string to initialize URL request from
    init?(gn_urlString: String) {
        guard let url = URL(string: gn_urlString) else { return nil }
        self.init(url: url)
    }
    
}
