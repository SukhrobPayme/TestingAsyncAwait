//
//  ImageFetcher.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import Foundation

protocol ImageFetcher {
    func fetchData(_ url: URL) async throws -> Data
}

final class DefaultImageFetcher: ImageFetcher {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            switch httpResponse.statusCode {
            case 400...499:
                throw NetworkError.internal(error: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.server(error: httpResponse.statusCode)
            default:
                throw NetworkError.unknown(error: httpResponse.statusCode)
            }
        }
        
        return data
    }
}
