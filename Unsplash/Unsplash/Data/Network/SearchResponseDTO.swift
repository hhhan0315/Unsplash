//
//  SearchResponseDTO.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

struct SearchResponseDTO: Codable {
    var results: [PhotoResponseDTO]
}
