//
//  SearchPhotoRequest.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

struct SearchPhotoRequest: DataRequestable {
    
    private let apiKey: String = "ZwdzXjUXEW3Yfja3LfGMmPCPbrIvDDtgqXPtoxh7eKg"
    private let query: String
    private let page: Int
    
    init(query: String, page: Int) {
        self.query = query
        self.page = page
    }

    var url: String {
        let baseURL: String = "https://api.unsplash.com"
        return baseURL + "/search/photos"
    }
    
    var headers: [String : String] {
        ["Authorization": "Client-ID \(self.apiKey)"]
    }
    
    var queryItems: [String : String] {
        ["query": self.query, "page": "\(self.page)", "per_page": "20"]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> SearchResult {
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResult.self, from: data)
        return response
    }
}
