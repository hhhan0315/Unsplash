//
//  PhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/09/16.
//

import Foundation

class PhotoRepository {
    private let apiCaller = APICaller()
    
    func fetch(topic: Topic, page: Int, completion: @escaping (Result<[PhotoEntity], APIError>) -> Void) {
        apiCaller.request(api: .getTopic(topic: topic, page: page)) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode([PhotoEntity].self, from: data) else {
                    completion(.failure(.DecodeError))
                    return
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
