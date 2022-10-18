//
//  TopicPhotoCellViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/30.
//

import Foundation

struct TopicPhotoCellViewModel {
    let id: String
    let title: String
    let slug: String
    let coverPhotoURL: String
}

extension TopicPhotoCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
