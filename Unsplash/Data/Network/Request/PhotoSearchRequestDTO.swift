//
//  PhotoSearchRequestDTO.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

struct PhotoSearchRequestDTO {
    let query: String
    let page: Int
    let perPage: Int = 10
}
