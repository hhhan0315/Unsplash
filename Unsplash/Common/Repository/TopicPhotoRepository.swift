//
//  TopicPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/09/26.
//

import Foundation

final class TopicPhotoRepository {
    private let apiCaller = APICaller()
    
    func fetch(slug: String, page: Int, completion: @escaping (Result<[PhotoEntity], APIError>) -> Void) {
        apiCaller.request(api: .getTopicPhotos(slug: slug, page: page),
                          dataType: [PhotoEntity].self) { result in
            switch result {
            case .success(let photoEntities):
                completion(.success(photoEntities))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
