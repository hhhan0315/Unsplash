//
//  GetPhotoListUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/12/24.
//

import Foundation

protocol GetPhotoListUseCase {
    func execute(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}

final class DefaultGetPhotoListUseCase: GetPhotoListUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        photoRepository.fetchPhotoList(page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
