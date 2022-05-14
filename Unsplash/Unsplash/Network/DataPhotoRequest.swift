//
//  DataPhotoRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

enum EndPointType {
    case topic(Topic)
    case search
}

struct DataPhotoRequest: DataRequestable {
        
    private let apiKey: String = "ZwdzXjUXEW3Yfja3LfGMmPCPbrIvDDtgqXPtoxh7eKg"
    private let endPointType: EndPointType
    
    init(endPointType: EndPointType) {
        self.endPointType = endPointType
    }
    
    var url: String {
        let baseURL: String = "https://api.unsplash.com"
        switch self.endPointType {
        case .topic(let topic):
            return baseURL + "/topics/\(topic.rawValue)/photos"
        case .search:
            return baseURL + "/search/photos"
            
        }
    }
    
    var headers: [String : String] {
        ["Authorization": "Client-ID \(self.apiKey)"]
    }
    
    var queryItems: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> [Photo] {
        let decoder = JSONDecoder()
        let response = try decoder.decode([Photo].self, from: data)
        return response
    }
}
