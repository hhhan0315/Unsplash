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
    
    case getListPhotos(page: Int)
    case getListTopics(page: Int)
    case getTopicPhotos(slug: String, page: Int)
    case getSearchPhotos(query: String, page: Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .getListPhotos:
            return "/photos"
        case .getListTopics:
            return "/topics"
        case .getTopicPhotos(let slug, _):
            return "/topics/\(slug)/photos"
        case .getSearchPhotos:
            return "/search/photos"
        }
    }
    
    var query: [String: String] {
        switch self {
        case .getListPhotos(let page):
            return ["page": "\(page)"]
        case .getListTopics(let page):
            return ["page": "\(page)", "per_page": "30"]
        case .getTopicPhotos(_, let page):
            return ["page": "\(page)", "per_page": "20"]
        case let .getSearchPhotos(query, page):
            return ["query": query, "page": "\(page)"]
        }
    }
    
    var header: [String: String] {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
