//
//  SearchResponseDTO.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let results: [PhotoResponseDTO]
}
