//
//  PhotoResponse.swift
//  Unsplash
//
//  Created by rae on 2022/05/04.
//

import Foundation

struct PhotoResponse: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLs
    let user: User
}

extension PhotoResponse {
    struct URLs: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

    struct User: Decodable {
        let name: String
    }
}

extension PhotoResponse: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PhotoResponse, rhs: PhotoResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
