//
//  TopicService.swift
//  Unsplash
//
//  Created by rae on 2022/09/23.
//

import Foundation

final class TopicService {
    private let topicRepository = TopicRepository()
    
    private var page = 1
    
    func fetch(completion: @escaping (Result<[Topic], APIError>) -> Void) {
        topicRepository.fetch(page: page) { result in
            switch result {
            case .success(let topicEntities):
                let topics = topicEntities.map {
                    Topic(id: $0.id,
                          title: $0.title,
                          slug: $0.slug,
                          coverPhotoURL: $0.coverPhoto.urls.small)
                }
                self.page += 1
                completion(.success(topics))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
