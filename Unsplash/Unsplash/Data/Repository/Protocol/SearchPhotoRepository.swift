//
//  SearchPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

protocol SearchPhotoRepository {
    func fetch(query: String, page: Int, completion: @escaping (Result<SearchResponse, Error>) -> Void)
}
