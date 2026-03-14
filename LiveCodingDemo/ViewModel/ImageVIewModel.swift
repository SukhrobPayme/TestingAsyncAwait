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
    @Published var users: UsersResponseDTO? = nil
    @Published var error: String? = nil
    @Published var isLoading: Bool = false
    
    private let networkManager: NetworkManager
    private let url = URL(string: "https://randomuser.me/api/?results=50")
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let url else { return }
            self.error = nil
            users = try await networkManager.fetch(url)
        } catch {
            self.error = error.localizedDescription
        }
    }
}


