//
//  DefaultTopicPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/05/14.
//

import Foundation

final class DefaultTopicPhotoRepository: TopicPhotoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetch(topic: Topic, page: Int, completion: @escaping (Result<[PhotoResponseDTO], Error>) -> Void) {
        let request = TopicPhotoRequest(topic: topic, page: page)
        self.networkService.request(request) { (result: Result<[PhotoResponseDTO], NetworkError>) in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
