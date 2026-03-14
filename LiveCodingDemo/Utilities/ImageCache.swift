//
//  ImageLoader.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

protocol ImageCache {
    func set(image: UIImage, name: String)
    func get(name: String) -> UIImage?
}

final class DefaultImageCache: ImageCache {
    static let shared = DefaultImageCache()
    
    private init() { }
    
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 200 // 200mb
        return cache
    }()
    
    func set(image: UIImage, name: String) {
        cache.setObject(image, forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        cache.object(forKey: name as NSString)
    }
}

