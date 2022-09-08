//
//  DataPhotoRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

struct TopicPhotoRequest: DataRequestable {
                
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
        ["Authorization": "Client-ID \(Constants.apiKey)"]
    }
    
    var queryItems: [String : String] {
        ["page": "\(self.page)"]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> [PhotoResponse] {
        let decoder = JSONDecoder()
        let response = try decoder.decode([PhotoResponse].self, from: data)
        return response
    }
}
