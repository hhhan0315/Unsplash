//
//  PhotoEntity.swift
//  Unsplash
//
//  Created by rae on 2022/05/04.
//

import Foundation

struct PhotoEntity: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLs
    let user: User
}

extension PhotoEntity {
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
