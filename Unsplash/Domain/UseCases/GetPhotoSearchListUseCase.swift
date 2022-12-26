//
//  GetPhotoSearchListUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/12/26.
//

import Foundation

protocol GetPhotoSearchListUseCase {
    func execute(query: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}

final class DefaultGetPhotoSearchListUseCase: GetPhotoSearchListUseCase {
    private let photoSearchRepository: PhotoSearchRepository
    
    init(photoSearchRepository: PhotoSearchRepository) {
        self.photoSearchRepository = photoSearchRepository
    }
    
    func execute(query: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        photoSearchRepository.fetchSearchPhotos(query: query, page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
