//
//  TargetType.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol TargetType {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var query: [String: String]? { get }
    var headers: [String: String]? { get }
}
