//
//  PhotoService.swift
//  Unsplash
//
//  Created by rae on 2022/09/16.
//

import Foundation

class PhotoService {
    private let photoRepository = PhotoRepository()
    
    // 여기서 page를 가지고 있어야 할듯
    private var page: Int = 1
    
    func fetch(completion: @escaping (Result<[Photo], APIError>) -> Void) {
        photoRepository.fetch(page: page) { result in
            switch result {
            case .success(let photoEntities):
                let photos = photoEntities.map {
                    Photo(id: $0.id,
                          width: $0.width,
                          height: $0.height,
                          url: $0.urls.small,
                          user: $0.user.name)
                }
                self.page += 1
                completion(.success(photos))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
    
//    func fetch(topic: Topic, page: Int, completion: @escaping (Result<[Photo], APIError>) -> Void) {
//        photoRepository.fetch(topic: topic, page: page) { result in
//            switch result {
//            case .success(let photoEntities):
//                let photos = photoEntities.map {
//                    Photo(id: $0.id,
//                          width: $0.width,
//                          height: $0.height,
//                          url: $0.urls.small,
//                          user: $0.user.name)
//                }
//                completion(.success(photos))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
