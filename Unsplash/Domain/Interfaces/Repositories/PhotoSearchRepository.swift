//
//  PhotoSearchRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol PhotoSearchRepository {
    func fetchSearchPhotos(query: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}
