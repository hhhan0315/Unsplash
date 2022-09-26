//
//  Topic.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import Foundation

struct Topic {
    let id: String
    let title: String
    let slug: String
    let coverPhotoURL: String
}

extension Topic: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
