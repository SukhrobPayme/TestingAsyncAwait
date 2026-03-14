//
//  ContentView.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ImageViewModel

    var body: some View {
        NavigationView {
            List(viewModel.dataArray?.users ?? [], id: \.self, rowContent: { model in
                VStack {
                    imageRow(model: model)
                }
            })
            .navigationTitle("Downloading Image")
            .task {
                await viewModel.onLoad()
            }
            .refreshable {
                await viewModel.onLoad()
            }
        }
    }
    
    private func imageRow(model: UserDTO) -> some View {
        HStack {
            CachedAsyncImage(urlString: model.picture.medium) { image in
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipped()
                        .cornerRadius(6)
                } else {
                    Color.gray.opacity(0.15)
                        .frame(width: 75, height: 75)
                        .cornerRadius(6)
                }
            }

            VStack(alignment: .leading) {
                Text(model.name.first).font(.headline)
                Text(model.email).foregroundStyle(.gray).italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView(viewModel: ImageViewModel())
}
