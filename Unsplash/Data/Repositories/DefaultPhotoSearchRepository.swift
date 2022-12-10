//
//  DefaultPhotoSearchRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

final class DefaultPhotoSearchRepository {
    private let networkSerivce: NetworkService
    
    init(networkSerivce: NetworkService) {
        self.networkSerivce = networkSerivce
    }
}

extension DefaultPhotoSearchRepository: PhotoSearchRepository {
    func fetchSearchPhotos(query: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let photoSearchRequestDTO = PhotoSearchRequestDTO(query: query, page: page)
        
        networkSerivce.request(api: API.getSearchPhotos(photoSearchRequestDTO), dataType: SearchResponseDTO.self) { result in
            switch result {
            case .success(let searchResponseDTO):
                let photos = searchResponseDTO.results.map { $0.toDomain() }
                completion(.success(photos))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
