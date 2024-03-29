//
//  DefaultPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

final class DefaultPhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultPhotoRepository: PhotoRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let photoRequestDTO = PhotoRequestDTO(page: page)
        
        networkService.request(api: API.getListPhotos(photoRequestDTO), dataType: [PhotoResponseDTO].self) { result in
            switch result {
            case .success(let photoResponseDTOs):
                let photos = photoResponseDTOs.map { $0.toDomain() }
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
