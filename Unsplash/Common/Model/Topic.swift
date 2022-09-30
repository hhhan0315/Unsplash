//
//  Topic.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import Foundation

struct Topic: Decodable {
    let id: String
    let title: String
    let slug: String
    let coverPhoto: CoverPhoto
    
    enum CodingKeys: String, CodingKey {
        case coverPhoto = "cover_photo"
        case id, title, slug
    }
}

extension Topic {
    struct CoverPhoto: Decodable {
        let urls: URLs
        
        struct URLs: Decodable {
            let raw: String
            let full: String
            let regular: String
            let small: String
            let thumb: String
        }
    }
}
