//
//  PhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol PhotoRepository {
    func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}
