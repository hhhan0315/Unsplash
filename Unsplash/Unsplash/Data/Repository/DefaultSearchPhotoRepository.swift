//
//  DefaultSearchPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

final class DefaultSearchPhotoRepository: SearchPhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetch(query: String, page: Int, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
//        let request = SearchPhotoRequest(query: query, page: page)
//        self.networkService.request(request) { (result: Result<SearchResponse, NetworkError>) in
//            switch result {
//            case .success(let searchResult):
//                completion(.success(searchResult.results))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
