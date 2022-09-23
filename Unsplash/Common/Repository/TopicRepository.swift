//
//  TopicRepository.swift
//  Unsplash
//
//  Created by rae on 2022/09/23.
//

import Foundation

final class TopicRepository {
    private let apiCaller = APICaller()
    
    func fetch(page: Int, completion: @escaping (Result<[TopicEntity], APIError>) -> Void) {
        apiCaller.request(api: .getTopics(page: page),
                          dataType: [TopicEntity].self) { result in
            switch result {
            case .success(let topicEntities):
                completion(.success(topicEntities))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
