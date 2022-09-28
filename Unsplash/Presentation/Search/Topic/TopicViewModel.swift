//
//  TopicViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit

final class TopicViewModel {
    @Published var topics: [Topic] = []
    @Published var error: APIError? = nil
    
    private let topicService = TopicService()
    
    func topicsCount() -> Int {
        return topics.count
    }
    
    func topic(at index: Int) -> Topic {
        return topics[index]
    }
    
    func fetch() {
        topicService.fetch { result in
            switch result {
            case .success(let topics):
                self.topics.append(contentsOf: topics)
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
