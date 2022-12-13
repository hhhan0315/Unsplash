//
//  API.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

enum API: TargetType {    
    case getListPhotos(PhotoRequestDTO)
    case getListTopics(TopicRequestDTO)
    case getTopicPhotos(TopicPhotoRequestDTO)
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
        case .getTopicPhotos(let topicPhotoRequestDTO):
            return "/topics/\(topicPhotoRequestDTO.slug)/photos"
        case .getSearchPhotos:
            return "/search/photos"
        }
    }
    
    var query: [String: String]? {
        switch self {
        case .getListPhotos(let photoRequestDTO):
            return [
                "page": "\(photoRequestDTO.page)",
                "per_page": "\(photoRequestDTO.perPage)"
            ]
        case .getListTopics(let topicRequestDTO):
            return [
                "per_page": "\(topicRequestDTO.perPage)"
            ]
        case .getTopicPhotos(let topicPhotoRequestDTO):
            return [
                "page": "\(topicPhotoRequestDTO.page)",
                "per_page": "\(topicPhotoRequestDTO.perPage)"
            ]
        case .getSearchPhotos(let photoSearchRequestDTO):
            return [
                "query": photoSearchRequestDTO.query,
                "page": "\(photoSearchRequestDTO.page)",
                "per_page": "\(photoSearchRequestDTO.perPage)"
            ]
        }
    }
    
    var headers: [String: String]? {
        return ["Authorization": "Client-ID \(Secrets.clientID)"]
    }
}
