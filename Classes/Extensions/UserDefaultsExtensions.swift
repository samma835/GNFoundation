//
//  UserDefaultsExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

// MARK: - Methods
public extension UserDefaults {
    
    /// GNFoundation: get object from UserDefaults by using subscript
    ///
    /// - Parameter key: key in the current user's defaults database.
    subscript(gn_key: String) -> Any? {
        get {
            return object(forKey: gn_key)
        }
        set {
            set(newValue, forKey: gn_key)
        }
    }
    
    /// GNFoundation: Float from UserDefaults.
    ///
    /// - Parameter forKey: key to find float for.
    /// - Returns: Float object for key (if exists).
    func gn_float(forKey key: String) -> Float? {
        return object(forKey: key) as? Float
    }
    
    /// GNFoundation: Date from UserDefaults.
    ///
    /// - Parameter forKey: key to find date for.
    /// - Returns: Date object for key (if exists).
    func gn_date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    /// GNFoundation: Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Class that conforms to the Codable protocol.
    ///   - key: Identifier of the object.
    ///   - decoder: Custom JSONDecoder instance. Defaults to `JSONDecoder()`.
    /// - Returns: Codable object for key (if exists).
    func gn_object<T: Codable>(_ type: T.Type,
                                      with key: String,
                                      usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        
        return try? decoder.decode(type.self, from: data)
    }
    
    /// GNFoundation: Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - object: Codable object to store.
    ///   - key: Identifier of the object.
    ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
    func gn_set<T: Codable>(object: T,
                                   forKey key: String,
                                   usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
    
}
