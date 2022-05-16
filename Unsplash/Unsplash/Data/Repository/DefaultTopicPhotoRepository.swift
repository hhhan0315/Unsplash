//
//  DefaultTopicPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/05/14.
//

import Foundation

final class DefaultTopicPhotoRepository: TopicPhotoRepository {
    private let networkService: NetworkService
    
    init(service: NetworkService) {
        self.networkService = service
    }
    
    func fetch(topic: Topic, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let request = DataPhotoRequest(endPointType: EndPointType.topic(topic), page: page)
        self.networkService.request(request) { (result: Result<[Photo], NetworkError>) in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
