//
//  TopicResponseDTO+Mapping.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct TopicResponseDTO: Decodable {
    let id: String
    let title: String
    let slug: String
    let coverPhoto: CoverPhotoDTO
    
    enum CodingKeys: String, CodingKey {
        case coverPhoto = "cover_photo"
        case id, title, slug
    }
    
    struct CoverPhotoDTO: Decodable {
        let urls: URLDTO
        
        struct URLDTO: Decodable {
            let raw: String
            let full: String
            let regular: String
            let small: String
            let thumb: String
        }
    }
}

extension TopicResponseDTO {
    func toDomain() -> Topic {
        return .init(
            identifier: UUID(),
            id: id,
            title: title,
            slug: slug,
            coverPhoto: coverPhoto.toDomain()
        )
    }
}

extension TopicResponseDTO.CoverPhotoDTO {
    func toDomain() -> CoverPhoto {
        return .init(urls: urls.toDomain())
    }
}

extension TopicResponseDTO.CoverPhotoDTO.URLDTO {
    func toDomain() -> URLs {
        return .init(regular: regular)
    }
}
