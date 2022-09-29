//
//  TopicPhotoService.swift
//  Unsplash
//
//  Created by rae on 2022/09/26.
//

import Foundation

final class TopicPhotoService {
    private let topicPhotoRepository = TopicPhotoRepository()
    
    private var page = 1
    
    func fetch(slug: String, completion: @escaping (Result<[Photo], APIError>) -> Void) {
        topicPhotoRepository.fetch(slug: slug, page: page) { result in
            switch result {
            case .success(let photoEntities):
                let photos = photoEntities.map {
                    Photo(id: $0.id,
                          width: $0.width,
                          height: $0.height,
                          url: $0.urls.regular,
                          user: $0.user.name)
                }
                self.page += 1
                completion(.success(photos))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
