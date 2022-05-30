//
//  DefaultSearchPhotoUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

final class DefaultSearchPhotoUseCase: SearchPhotoUseCase {
    private let searchPhotoRepository: SearchPhotoRepository
    
    init(searchPhotoRepository: SearchPhotoRepository) {
        self.searchPhotoRepository = searchPhotoRepository
    }
    
    func fetch(query: String, page: Int, completion: @escaping (Result<[PhotoResponseDTO], Error>) -> Void) {
        self.searchPhotoRepository.fetch(query: query, page: page) { result in
            switch result {
            case .success(let photos):
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
