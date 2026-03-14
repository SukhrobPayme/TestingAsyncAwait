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
        NavigationStack {
            List(viewModel.users?.users ?? [], id: \.self) { model in
                NavigationLink {
                    userProfile(model)
                } label: {
                    userRow(model)
                }


            }
            .task {
                await viewModel.fetchData()
            }
            .refreshable {
                await viewModel.fetchData()
            }
        }
    }
    
    private func userRow(_ model: UserDTO) -> some View {
        HStack {
            CachedAsyncImage(content: { image in
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 75, height: 75, alignment: .leading)
                    .clipped()
            }, urlString: model.picture.medium)
            VStack(alignment: .leading) {
                Text(model.name.first)
                Text(model.email)
            }
        }
    }
    
    private func userProfile(_ model: UserDTO) -> some View {
        VStack {
            CachedAsyncImage(content: { image in
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 275, height: 275, alignment: .leading)
                    .clipped()
            }, urlString: model.picture.medium)
            Text(model.name.first + " " + model.name.last)
            Text(model.email)
        }
    }
}

#Preview {
    ContentView(viewModel: ImageViewModel(networkManager: DefaultNetworkManager()))
}
