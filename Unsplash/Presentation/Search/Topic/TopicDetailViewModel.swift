//
//  TopicDetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/26.
//

import Foundation

final class TopicDetailViewModel {
    @Published var photos: [Photo] = []
    @Published var error: APIError? = nil
    
    private let topicPhotoService = TopicPhotoService()
    private var slug: String
    
    init(slug: String) {
        self.slug = slug
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        topicPhotoService.fetch(slug: slug) { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
