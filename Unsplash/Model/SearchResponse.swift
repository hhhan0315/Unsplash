//
//  SearchResponse.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

struct SearchResponse: Decodable {
    var results: [PhotoResponse]
}
