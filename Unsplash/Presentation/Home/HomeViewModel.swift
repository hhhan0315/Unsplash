//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit

class HomeViewModel {
    @Published var photoResponses: [PhotoResponse]
    private var topics: [Topic]
    private var currentTopic: Topic
    private var page: Int
    private let apiCaller: APICaller
    
    init() {
        self.photoResponses = []
        self.topics = Topic.allCases
        self.currentTopic = .wallpapers
        self.page = 1
        self.apiCaller = APICaller()
    }
    
    func photoResponsesCount() -> Int {
        return photoResponses.count
    }
    
    func photoResponse(at index: Int) -> PhotoResponse {
        return photoResponses[index]
    }
    
    func topicsCount() -> Int {
        return topics.count
    }
    
    func topic(at index: Int) -> Topic {
        return topics[index]
    }
    
    func fetch() {
        apiCaller.request(api: .getTopic(topic: currentTopic, page: page),
                          dataType: [PhotoResponse].self) { [weak self] result in
            switch result {
            case .success(let photoResponses):
                self?.photoResponses.append(contentsOf: photoResponses)
                self?.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(with topic: Topic) {
        guard self.currentTopic != currentTopic else { return }
        self.currentTopic = topic
        photoResponses.removeAll()
        page = 1
        fetch()
    }
}
