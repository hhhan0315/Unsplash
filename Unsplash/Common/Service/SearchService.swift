//
//  SearchService.swift
//  Unsplash
//
//  Created by rae on 2022/09/17.
//

import Foundation

class SearchService {
    private let searchRepository = SearchRepository()
    
    func fetch(query: String, page: Int, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        searchRepository.fetch(query: query, page: page) { result in
            switch result {
            case .success(let searchEntity):
                let photos = searchEntity.results.map {
                    Photo(id: $0.id,
                          width: $0.width,
                          height: $0.height,
                          url: $0.urls.small,
                          user: $0.user.name)
                }
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}