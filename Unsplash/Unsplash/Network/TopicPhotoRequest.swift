//
//  TopicPhotoRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

struct TopicPhotoRequest: DataRequestable {
        
    private let apiKey: String = "ZwdzXjUXEW3Yfja3LfGMmPCPbrIvDDtgqXPtoxh7eKg"
    private let topic: Topic
    
    init(topic: Topic) {
        self.topic = topic
    }
    
    var url: String {
        let baseURL: String = "https://api.unsplash.com"
        let path: String = "/topics/\(self.topic.rawValue)/photos"
        return baseURL + path
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
