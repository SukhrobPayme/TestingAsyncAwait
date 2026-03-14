//
//  ImageLoader.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI
import Combine

protocol ImageLoaderProtocol: ObservableObject {
    var image: UIImage? { get }
    var isLoading: Bool { get }
    func load(from urlString: String)
    func cancel()
}

@MainActor
final class DefaultImageLoader: ImageLoaderProtocol {
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

    func load(from urlString: String) {
        if let cached = cache.get(key: urlString) {
            self.image = cached
            return
        }

        task?.cancel()
        task = Task {
            isLoading = true
            defer { isLoading = false }

            guard
                let url = URL(string: urlString),
                let data = try? await fetcher.fetch(url),
                let uiImage = UIImage(data: data),
                !Task.isCancelled
            else { return }
            cache.set(key: urlString, image: uiImage)
            self.image = uiImage
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
