//
//  CachedAsyncImage.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI
import Combine

struct CachedAsyncImage<Content: View, Loader: ImageLoaderProtocol>: View {
    private let urlString: String
    private let content: (UIImage?) -> Content

    @StateObject private var loader: Loader

    init(
        urlString: String,
        loader: Loader = DefaultImageLoader(),
        @ViewBuilder content: @escaping (UIImage?) -> Content
    ) {
        self.urlString = urlString
        self._loader = StateObject(wrappedValue: loader)
        self.content = content
    }

    var body: some View {
        ZStack {
            content(loader.image)

            if loader.isLoading {
                ProgressView()
            }
        }
        .task { loader.load(from: urlString) }
        .onDisappear { loader.cancel() }
    }
}
