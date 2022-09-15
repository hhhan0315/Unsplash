//
//  API.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

// 열거형을 사용해 구현(열거형을 선택한 이유는 네트워크 주소 case에 따라 구분 가능)
enum API {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    // 연관값을 활용해 구체적인 정보 저장
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
        // 변수에 바인딩해서 사용 (방법 1)
        case .getTopic(let topic, _):
            return "/topics/\(topic.rawValue)/photos"
        case .getSearch:
            return "/search/photos"
        }
    }
    
    var query: [String: String] {
        switch self {
        // 변수에 바인딩해서 사용 (방법 2)
        case let .getTopic(_, page):
            return ["page": "\(page)"]
        case let .getSearch(query, page):
            return ["query": query, "page": "\(page)"]
        }
    }
    
    var header: [String: String] {
        return ["Authorization": "Client-ID \(Constants.apiKey)"]
    }
}
