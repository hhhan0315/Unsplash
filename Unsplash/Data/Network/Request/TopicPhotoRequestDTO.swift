//
//  TopicPhotoRequestDTO.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import Foundation

struct TopicPhotoRequestDTO {
    let slug: String
    let page: Int
    let perPage: Int = 10
}
