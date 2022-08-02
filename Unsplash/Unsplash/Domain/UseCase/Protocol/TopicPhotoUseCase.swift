//
//  TopicPhotoUseCase.swift
//  Unsplash
//
//  Created by rae on 2022/05/14.
//

import Foundation

protocol TopicPhotoUseCase {
    func fetch(topic: Topic, page: Int, completion: @escaping(Result<[PhotoResponse], Error>) -> Void)
}
