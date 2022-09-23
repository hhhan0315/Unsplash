//
//  SearchEntity.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

struct SearchEntity: Decodable {
    let results: [PhotoEntity]
}
