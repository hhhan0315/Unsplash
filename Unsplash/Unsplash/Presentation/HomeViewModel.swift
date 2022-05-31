//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import UIKit

enum ViewModelState {
    case ready
    case loading
}

class HomeViewModel {
    
    private let topicPhotoUseCase: TopicPhotoUseCase
    private(set) var photos: Observable<[Photo]>
    private(set) var topic: Topic
    private(set) var page: Int
    private var state: ViewModelState
    
    init(topicPhotoUseCase: TopicPhotoUseCase) {
        self.topicPhotoUseCase = topicPhotoUseCase
        self.photos = Observable([])
        self.topic = .wallpapers
        self.page = 1
        self.state = .ready
    }
    
    func fetch() {
        guard self.state == .ready else { return }
        self.state = .loading

        self.topicPhotoUseCase.fetch(topic: self.topic, page: self.page) { [weak self] result in
            switch result {
            case .success(let photoResponseDTOs):
                var photos = [Photo]()
                
                photoResponseDTOs.forEach { photoResponseDTO in
                    let photo = photoResponseDTO.toDomain()
                    guard let url = photo.imageUrl else { return }

                    ImageLoader.shared.load(url) { data in
                        photo.image = UIImage(data: data)
                        photos.append(photo)
                        if photos.count == Constants.perPageCount {
                            self?.photos.value.append(contentsOf: photos)
                            self?.state = .ready
                        }
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
