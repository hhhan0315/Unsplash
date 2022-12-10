//
//  API.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

enum API: TargetType {    
    case getListPhotos(PhotoRequestDTO)
    case getListTopics
    case getTopicPhotos(slug: String, page: Int)
    case getSearchPhotos(PhotoSearchRequestDTO)
    
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
    
    var query: [String: String]? {
        switch self {
        case .getListPhotos(let photoRequestDTO):
            return ["page": "\(photoRequestDTO.page)",
                    "per_page": "\(photoRequestDTO.perPage)"]
        case .getListTopics:
            return nil
        case .getTopicPhotos(_, let page):
            return ["page": "\(page)", "per_page": "\(Constants.perPage)"]
        case .getSearchPhotos(let photoSearchRequestDTO):
            return ["query": photoSearchRequestDTO.query,
                    "page": "\(photoSearchRequestDTO.page)",
                    "per_page": "\(photoSearchRequestDTO.perPage)"]
        }
    }
    
    var headers: [String: String]? {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
