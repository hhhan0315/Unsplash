//
//  GetTopicPhotoListUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/12/24.
//

import Foundation

protocol GetTopicPhotoListUseCase {
    func execute(slug: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}

final class DefaultGetTopicPhotoListUseCase: GetTopicPhotoListUseCase {
    private let topicPhotoRepository: TopicPhotoRepository
    
    init(topicPhotoRepository: TopicPhotoRepository) {
        self.topicPhotoRepository = topicPhotoRepository
    }
    
    func execute(slug: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        topicPhotoRepository.fetchTopicPhotoList(slug: slug, page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
