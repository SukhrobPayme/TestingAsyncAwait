//
//  CachedAsyncImage.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    @StateObject private var imageLoader = DefaultImageLoader()
    
    private let content: (Image) -> Content
    private let urlString: String
    
    init(
        content: @escaping (Image) -> Content,
        urlString: String
    ) {
        self.content = content
        self.urlString = urlString
    }
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                content(Image(uiImage: image))
            }
            
            if imageLoader.isLoading {
                ProgressView()
            }
        }
        .task {
            imageLoader.loadFrom(urlString)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
