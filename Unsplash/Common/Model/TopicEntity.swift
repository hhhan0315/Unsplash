//
//  TopicEntity.swift
//  Unsplash
//
//  Created by rae on 2022/09/23.
//

import Foundation

struct TopicEntity: Decodable {
    let id: String
    let title: String
    let slug: String
    let coverPhoto: CoverPhoto
    
    enum CodingKeys: String, CodingKey {
        case coverPhoto = "cover_photo"
        case id, title, slug
    }
}

extension TopicEntity {
    struct CoverPhoto: Decodable {
        let urls: URLs
        
        struct URLs: Decodable {
            let small: String
        }
    }
}
