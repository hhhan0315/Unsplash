//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit

class HomeViewModel {
    @Published var photos: [PhotoResponse]
    private var topic: Topic
    private var page: Int
    private let apiCaller: APICaller
    
    init() {
        self.photos = []
        self.topic = .wallpapers
        self.page = 1
        self.apiCaller = APICaller()
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> PhotoResponse {
        return photos[index]
    }
    
    func fetch() {
        apiCaller.request(api: .getTopic(topic: topic, page: page),
                          dataType: [PhotoResponse].self) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                self?.page += 1
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
