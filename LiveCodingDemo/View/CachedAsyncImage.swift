//
//  CachedAsyncImage.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    private let urlString: String
    private let content: (UIImage?) -> Content

    @StateObject private var loader = DefaultImageLoader()

    init(
        urlString: String,
        @ViewBuilder content: @escaping (UIImage?) -> Content
    ) {
        self.urlString = urlString
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
