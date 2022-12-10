//
//  Topic.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct Topic {
    let identifier: UUID
    let id: String
    let title: String
    let slug: String
    let coverPhoto: CoverPhoto
}

struct CoverPhoto {
    let urls: URLs
}

extension Topic: Hashable, Equatable {
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
