//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit

final class SearchViewModel {
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
//        searchService.fetch(query: query, page: page) { [weak self] result in
//            switch result {
//            case .success(let photos):
//                self?.photos.append(contentsOf: photos)
//                self?.page += 1
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func update(_ query: String) {
//        guard self.query != query else {
//            return
//        }
//        self.query = query
//        photos.removeAll()
//        page = 1
//        fetch()
    }
}
