//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit

class HomeViewModel {
    
    private let topicPhotoUseCase: TopicPhotoUseCase
    private(set) var photos: Observable<[Photo]>
    private(set) var topic: Topic
    private(set) var page: Int
    
    init(topicPhotoUseCase: TopicPhotoUseCase) {
        self.topicPhotoUseCase = topicPhotoUseCase
        self.photos = Observable([])
        self.topic = .wallpapers
        self.page = 1
    }
    
    func fetch() {
        self.topicPhotoUseCase.fetch(topic: self.topic, page: self.page) { [weak self] result in
            switch result {
            case .success(let photoResponseDTOs):
                photoResponseDTOs.forEach { photo in
                    let photoItem = photo.toDomain()
                    guard let url = photoItem.imageUrl else { return }
                    
                    ImageLoader.shared.load(url) { data in
                        photoItem.image = UIImage(data: data)
                        self?.photos.value.append(photoItem)
                    }
                }
                
                self?.page += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(_ topic: Topic) {
        guard self.topic != topic else { return }
        self.topic = topic
        self.photos.value.removeAll()
        self.page = 1
        self.fetch()
    }
}
