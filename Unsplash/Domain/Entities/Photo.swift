//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct Photo {
    let identifier: UUID
    let id: String
    let width: CGFloat
    let height: CGFloat
    let urls: URLs
    let links: Links
    let user: User
}

struct URLs {
    let regular: String
}

struct Links {
    let html: String
}

struct User {
    let name: String
}

extension Photo: Hashable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
}
