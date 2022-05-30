//
//  DefaultTopicPhotoUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/05/14.
//

import Foundation

final class DefaultTopicPhotoUseCase: TopicPhotoUseCase {
    private let topicPhotoRepository: TopicPhotoRepository
    
    init(topicPhotoRepository: TopicPhotoRepository) {
        self.topicPhotoRepository = topicPhotoRepository
    }
    
    func fetch(topic: Topic, page: Int, completion: @escaping (Result<[PhotoResponseDTO], Error>) -> Void) {
        self.topicPhotoRepository.fetch(topic: topic, page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
