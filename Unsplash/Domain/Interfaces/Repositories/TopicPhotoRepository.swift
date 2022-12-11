//
//  TopicPhotoRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import Foundation

protocol TopicPhotoRepository {
    func fetchTopicPhotoList(slug: String, page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}
