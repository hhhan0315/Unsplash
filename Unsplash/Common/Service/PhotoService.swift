//
//  PhotoService.swift
//  Unsplash
//
//  Created by rae on 2022/09/16.
//

import Foundation

final class PhotoService {
    private let photoRepository = PhotoRepository()
    
    private var page: Int = 1
    
    func fetch(completion: @escaping (Result<[Photo], APIError>) -> Void) {
        photoRepository.fetch(page: page) { result in
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
