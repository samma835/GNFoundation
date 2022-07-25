//
//  URLExtensions.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import AVFoundation


// MARK: - Properties
public extension URL {
    
    /// GNFoundation: Dictionary of the URL's query parameters
    var gn_queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        return items
    }
}

// MARK: - Methods
public extension URL {
    
    /// GNFoundation: URL with appending query parameters.
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.gn_appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    func gn_appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
    /// GNFoundation: Append query parameters to URL.
    ///
    ///        var url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.gn_appendQueryParameters(params)
    ///        print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    mutating func gn_appendQueryParameters(_ parameters: [String: String]) {
        self = gn_appendingQueryParameters(parameters)
    }
}


// MARK: - Methods
public extension URL {
    
    /// Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete. It's recommended to dispatch the call if the thumbnail is not generated from a local resource.
    ///
    ///     var url = URL(string: "https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.gn_thumbnail()
    ///     thumbnail = url.gn_thumbnail(fromTime: 5)
    ///
    ///     DisptachQueue.main.async {
    ///         someImageView.image = url.gn_thumbnail()
    ///     }
    ///
    /// - Parameter time: Seconds into the video where the image should be generated.
    /// - Returns: The UIImage result of the AVAssetImageGenerator
    func gn_thumbnail(fromTime time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        
        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}


