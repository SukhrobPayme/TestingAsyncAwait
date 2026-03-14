//
//  NetworkManager.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import Foundation

protocol NetworkManager {
    func fetch<T>(_ url: URL) async throws -> T where T : Decodable
}

final class DefaultNetworkManager: NetworkManager {
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    
    func fetch<T>(_ url: URL) async throws -> T where T : Decodable {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            switch httpResponse.statusCode {
            case 400...499:
                throw NetworkError.internal(errorCode: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.server(errorCode: httpResponse.statusCode)
            default:
                throw NetworkError.unknown(errorCode: httpResponse.statusCode)
            }
        }
        
        let result = try decoder.decode(T.self, from: data)
        return result
    }
}

enum NetworkError: Error {
    case `internal`(errorCode: Int)
    case server(errorCode: Int)
    case unknown(errorCode: Int)
}
