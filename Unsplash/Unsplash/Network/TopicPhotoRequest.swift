//
//  DataPhotoRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

struct TopicPhotoRequest: DataRequestable {
                
    private let apiKey: String = "ZwdzXjUXEW3Yfja3LfGMmPCPbrIvDDtgqXPtoxh7eKg"
    private let topic: Topic
    private let page: Int
    
    init(topic: Topic, page: Int) {
        self.topic = topic
        self.page = page
    }

    var url: String {
        let baseURL: String = "https://api.unsplash.com"
        return baseURL + "/topics/\(self.topic.rawValue)/photos"
    }
    
    var headers: [String : String] {
        ["Authorization": "Client-ID \(self.apiKey)"]
    }
    
    var queryItems: [String : String] {
        ["page": "\(self.page)", "per_page": "20"]
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
