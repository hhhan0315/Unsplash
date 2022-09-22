//
//  PhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/09/16.
//

import Foundation

final class PhotoRepository {
    private let apiCaller = APICaller()
    
    func fetch(page: Int, completion: @escaping (Result<[PhotoEntity], APIError>) -> Void) {
        apiCaller.request(api: .getPhotos(page: page),
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
