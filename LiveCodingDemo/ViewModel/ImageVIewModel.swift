//
//  ImageVIewModel.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import Combine
import SwiftUI

@MainActor
final class ImageViewModel: ObservableObject {
    @Published var dataArray: UsersResponseDTO? = nil
    @Published var error: String? = nil
    @Published var isLoading: Bool = false
    
    private let manager: NetworkManager = DefaultNetworkManager()
    private let urlOptional = URL(string: "https://randomuser.me/api/?results=50")
    
    func onLoad() async {
        await fetchData(urlOptional)
    }
    
    func fetchData(_ url: URL?) async {
        do {
            guard let url else { throw URLError(.badURL) }
            try Task.checkCancellation()
            dataArray = try await manager.fetch(url)
        } catch {
            debugPrint(error.localizedDescription)
            self.error = error.localizedDescription
        }
    }
}
