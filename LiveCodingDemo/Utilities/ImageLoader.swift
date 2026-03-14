//
//  ImageLoader.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI
import Combine

protocol ImageLoader: ObservableObject {
    var image: UIImage? { get }
    var isLoading: Bool { get }
    func loadFrom(_ urlString: String)
    func cancel()
}

@MainActor
final class DefaultImageLoader: ImageLoader {
    @Published private(set) var image: UIImage? = nil
    @Published private(set) var isLoading: Bool = false
    
    private let cache: ImageCache
    private let fetcher: ImageFetcher
    
    private var task: Task<Void, Never>?
    
    init(
        cache: ImageCache = DefaultImageCache.shared,
        fetcher: ImageFetcher = DefaultImageFetcher()
    ) {
        self.cache = cache
        self.fetcher = fetcher
    }
    
    func loadFrom(_ urlString: String) {
        if let image = cache.get(name: urlString) {
            self.image = image
        }
        
        task?.cancel()
        task = Task {
            isLoading = true
            defer { isLoading = false }
            
            guard
                let url = URL(string: urlString),
                let data = try? await fetcher.fetchData(url),
                let image = UIImage(data: data),
                !Task.isCancelled
            else { return }
            cache.set(image: image, name: urlString)
            self.image = image
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
}
