//
//  Topic.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import Foundation

// CaseIterable: 배열 컬렉션과 같이 순회할 수 있도록 해줌
enum Topic: String, CaseIterable {
    case editorial = "Editorial"
    case digitalNomad = "Digital Nomad"
    case currentEvents = "Current Events"
    case wallpapers = "Wallpapers"
    case texturesPatterns = "Textures & Patterns"
    case experimental = "Experimental"
    case architecture = "Architecture"
    case nature = "Nature"
    case fashion = "Fashion"
    case film = "Film"
    case people = "People"
}
