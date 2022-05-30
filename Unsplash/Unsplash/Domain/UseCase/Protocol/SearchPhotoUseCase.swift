//
//  SearchPhotoUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

protocol SearchPhotoUseCase {
    func fetch(query: String, page: Int, completion: @escaping (Result<[PhotoResponseDTO], Error>) -> Void)
}
