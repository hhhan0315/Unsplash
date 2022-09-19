//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit

class HomeViewModel {
    private(set) var photos: [Photo]
    private var topics: [Topic]
    private var currentTopic: Topic
    private var page: Int
    private let photoService: PhotoService
    
    private var updating: Bool
    
    var fetchEnded: () -> Void = {}
    var updateEnded: () -> Void = {}
    
    init() {
        self.photos = []
        self.topics = Topic.allCases
        self.currentTopic = .wallpapers
        self.page = 1
        self.photoService = PhotoService()
        self.updating = false
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func topicsCount() -> Int {
        return topics.count
    }
    
    func topic(at index: Int) -> Topic {
        return topics[index]
    }
    
    func fetch() {
        photoService.fetch(topic: currentTopic, page: page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                self?.page += 1
                self?.fetchEnded()
                
                if self?.updating == true {
                    self?.updateEnded()
                    self?.updating = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(with topic: Topic) {
        guard currentTopic != topic else {
            return
        }
        currentTopic = topic
        photos.removeAll()
        page = 1
        updating = true
        fetch()
    }
}
