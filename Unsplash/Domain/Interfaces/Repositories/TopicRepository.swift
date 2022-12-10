//
//  TopicRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol TopicRepository {
    func fetchTopicList(completion: @escaping (Result<[Topic], NetworkError>) -> Void)
}
