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
        apiCaller.request(api: .getPhotos(page: page)) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode([PhotoEntity].self, from: data) else {
                    completion(.failure(.decodeError))
                    return
                }
                completion(.success(decodedData))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
