//
//  DefaultTopicRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

final class DefaultTopicRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultTopicRepository: TopicRepository {
    func fetchTopicList(completion: @escaping (Result<[Topic], NetworkError>) -> Void) {
        networkService.request(api: API.getListTopics, dataType: [TopicResponseDTO].self) { result in
            switch result {
            case .success(let topicResponseDTOs):
                let topics = topicResponseDTOs.map { $0.toDomain() }
                completion(.success(topics))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
