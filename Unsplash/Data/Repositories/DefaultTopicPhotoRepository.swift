//
//  DefaultTopicPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import Foundation

final class DefaultTopicPhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultTopicPhotoRepository: TopicPhotoRepository {
    func fetchTopicPhotoList(slug: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let topicPhotoRequestDTO = TopicPhotoRequestDTO(slug: slug, page: page)
        
        networkService.request(api: API.getTopicPhotos(topicPhotoRequestDTO), dataType: [PhotoResponseDTO].self) { result in
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
