//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit
import Combine

class HomeViewModel {
    @Published var photos: [PhotoResponse]
    private var topic: Topic
    private var page: Int
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.photos = []
        self.topic = .wallpapers
        self.page = 1
        self.networkService = networkService
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> PhotoResponse {
        return photos[index]
    }
    
    func fetch() {
        let request = TopicPhotoRequest(topic: topic, page: page)
        networkService.request(request) { (result: Result<[PhotoResponse], NetworkError>) in
            switch result {
            case .success(let photoResponses):
                self.photos.append(contentsOf: photoResponses)
                self.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(with topic: Topic) {
        guard self.topic != topic else { return }
        self.topic = topic
        photos.removeAll()
        page = 1
        fetch()
    }
}
