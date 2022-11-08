//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/09/16.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let urls: URLs
    let user: User
}

extension Photo {
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

extension Photo: Hashable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
