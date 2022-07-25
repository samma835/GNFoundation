//
//  FileManagerExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation

public extension FileManager {
    
    /// GNFoundation: Read from a JSON file at a given path.
    ///
    /// - Parameters:
    ///   - path: JSON file path.
    ///   - options: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    func gn_jsonFromFile(atPath path: String,
                                readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
        
        return json as? [String: Any]
    }
    
    /// GNFoundation: Read from a JSON file with a given filename.
    ///
    /// - Parameters:
    ///   - filename: File to read.
    ///   - bundleClass: Bundle where the file is associated.
    ///   - readingOptions: JSONSerialization reading options.
    /// - Returns: Optional dictionary.
    /// - Throws: Throws any errors thrown by Data creation or JSON serialization.
    func gn_jsonFromFile(withFilename filename: String,
                                at bundleClass: AnyClass? = nil,
                                readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        // https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
        
        // To handle cases that provided filename has an extension
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main
        
        if let path = bundle.path(forResource: name, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
            
            return json as? [String: Any]
        }
        
        return nil
    }
    
    
    // MARK: - Common Directories
    
    static var gn_temporaryDirectoryPath: String {
        return NSTemporaryDirectory()
    }
    
    static var gn_temporaryDirectoryURL: URL {
        return URL(fileURLWithPath: FileManager.gn_temporaryDirectoryPath, isDirectory: true)
    }
    
    // MARK: - File System Modification
    @discardableResult
    static func gn_createDirectory(atPath path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func gn_createDirectory(at url: URL) -> Bool {
        return gn_createDirectory(atPath: url.path)
    }
    
    @discardableResult
    static func gn_removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func gn_removeItem(at url: URL) -> Bool {
        return gn_removeItem(atPath: url.path)
    }
    
    @discardableResult
    static func gn_removeAllItemsInsideDirectory(atPath path: String) -> Bool {
        let enumerator = FileManager.default.enumerator(atPath: path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let success = gn_removeItem(atPath: path + "/\(fileName)")
            if !success { result = false }
        }
        
        return result
    }
    
    @discardableResult
    static func gn_removeAllItemsInsideDirectory(at url: URL) -> Bool {
        return gn_removeAllItemsInsideDirectory(atPath: url.path)
    }
    
}
