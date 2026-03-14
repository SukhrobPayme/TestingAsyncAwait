//
//  PhotoModel.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import Foundation

struct UsersResponseDTO: Decodable, Hashable {
    let users: [UserDTO]
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
    }
}

struct UserDTO: Decodable, Hashable {
    let name: NameDTO
    let email: String
    let picture: PictureDTO
}

extension UserDTO {
    struct NameDTO: Decodable, Hashable {
        let first: String
        let last: String
    }
    
    struct PictureDTO: Decodable, Hashable {
        let large: String
        let medium: String
        let thumbnail: String
    }
}
