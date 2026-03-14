//
//  ImageLoader.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

protocol ImageCache {
    func get(key: String) -> UIImage?
    func set(key: String, image: UIImage)
}

final class DefaultImageCache: ImageCache {
    static let shared = DefaultImageCache()
    
    private init() { }
    
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 10
        return cache
    }()
    
    func get(key: String) -> UIImage? {
        print("Get from Saved")
        return cache.object(forKey: key as NSString)
    }
    
    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
}
