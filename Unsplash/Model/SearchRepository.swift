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
        apiCaller.request(api: .getSearch(query: query, page: page)) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(SearchEntity.self, from: data) else {
                    completion(.failure(.DecodeError))
                    return
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
