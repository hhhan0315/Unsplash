//
//  Topic.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import Foundation

// CaseIterable: 배열 컬렉션과 같이 순회할 수 있도록 해줌

enum Topic: String, CaseIterable {
    case editorial
    case wallpapers
    case experimental
    case architecture
    case nature
    case fashion
    case film
    case people
}
