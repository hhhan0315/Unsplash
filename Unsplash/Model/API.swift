//
//  API.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

enum API {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    case getPhotos(page: Int)
    case getTopic(topic: Topic, page: Int)
    case getSearch(query: String, page: Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/photos"
        case .getTopic(let topic, _):
            return "/topics/\(topic.rawValue)/photos"
        case .getSearch:
            return "/search/photos"
        }
    }
    
    var query: [String: String] {
        switch self {
        case let .getPhotos(page):
            return ["page": "\(page)"]
        case let .getTopic(_, page):
            return ["page": "\(page)"]
        case let .getSearch(query, page):
            return ["query": query, "page": "\(page)"]
        }
    }
    
    var header: [String: String] {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
