//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/05/04.
//

import Foundation

struct Photo: Codable, Hashable, Equatable {
    let id: String
    let urls: Urls
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
