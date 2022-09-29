//
//  SearchService.swift
//  Unsplash
//
//  Created by rae on 2022/09/17.
//

import Foundation

final class SearchService {
    private let searchRepository = SearchRepository()
    
    private var page: Int = 1
    
    func fetch(query: String, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        searchRepository.fetch(query: query, page: page) { result in
            switch result {
            case .success(let searchEntity):
                let photos = searchEntity.results.map {
                    Photo(id: $0.id,
                          width: $0.width,
                          height: $0.height,
                          url: $0.urls.regular,
                          user: $0.user.name)
                }
                self.page += 1
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resetPage() {
        page = 1
    }
}
