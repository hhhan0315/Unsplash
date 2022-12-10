//
//  PhotoResponseDTO+Mapping.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct PhotoResponseDTO: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let urls: URLDTO
    let user: UserDTO
    
    struct URLDTO: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct UserDTO: Decodable {
        let name: String
    }
}

extension PhotoResponseDTO {
    func toDomain() -> Photo {
        return .init(identifier: UUID(),
                     id: id,
                     width: width,
                     height: height,
                     urls: urls.toDomain(),
                     user: user.toDomain())
    }
}

extension PhotoResponseDTO.URLDTO {
    func toDomain() -> URLs {
        return .init(regular: regular)
    }
}

extension PhotoResponseDTO.UserDTO {
    func toDomain() -> User {
        return .init(name: name)
    }
}
