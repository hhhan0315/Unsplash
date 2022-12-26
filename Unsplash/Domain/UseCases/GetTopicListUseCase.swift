//
//  GetTopicListUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/12/24.
//

import Foundation

protocol GetTopicListUseCase {
    func execute(completion: @escaping (Result<[Topic], NetworkError>) -> Void)
}

final class DefaultGetTopicListUseCase: GetTopicListUseCase {
    private let topicRepository: TopicRepository
    
    init(topicRepository: TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    func execute(completion: @escaping (Result<[Topic], NetworkError>) -> Void) {
        topicRepository.fetchTopicList { result in
            switch result {
            case .success(let topics):
                completion(.success(topics))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
