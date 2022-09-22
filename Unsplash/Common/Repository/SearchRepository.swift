//
//  SearchRepository.swift
//  Unsplash
//
//  Created by rae on 2022/09/17.
//

import Foundation

class SearchRepository {
    private let apiCaller = APICaller()
    
    func fetch(query: String, page: Int, completion: @escaping (Result<SearchEntity, APIError>) -> Void) {
        apiCaller.request(api: .getSearch(query: query, page: page),
                          dataType: SearchEntity.self) { result in
            switch result {
            case .success(let searchEntity):
                completion(.success(searchEntity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
