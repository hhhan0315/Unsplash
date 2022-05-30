//
//  PhotoResponseDTO.swift
//  Unsplash
//
//  Created by rae on 2022/05/04.
//

import Foundation

struct PhotoResponseDTO: Codable {
    let urls: UrlsResponseDTO
    let user: UserResponseDTO
}

extension PhotoResponseDTO {
    struct UrlsResponseDTO: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    struct UserResponseDTO: Codable {
        let name: String
    }
}

extension PhotoResponseDTO {
    func toDomain() -> Photo {
        return Photo(image: nil, imageUrl: URL(string: urls.small))
    }
}
