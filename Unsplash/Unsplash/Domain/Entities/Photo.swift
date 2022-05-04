//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/05/04.
//

import Foundation

struct Photo: Codable {
    var id: String
    var urls: URLs
}

struct URLs: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
