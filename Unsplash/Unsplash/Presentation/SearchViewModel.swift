//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit

class SearchViewModel {
    private let searchPhotoUseCase: SearchPhotoUseCase
    private(set) var photos: Observable<[Photo]>
    private(set) var query: String
    private(set) var page: Int
    
    init(searchPhotoUseCase: SearchPhotoUseCase) {
        self.searchPhotoUseCase = searchPhotoUseCase
        self.photos = Observable([])
        self.query = ""
        self.page = 1
    }
    
    func fetch() {
        self.searchPhotoUseCase.fetch(query: self.query, page: self.page) { [weak self] result in
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
                print(error)
            }
        }
    }
    
    func update(_ query: String) {
        guard self.query != query else { return }
        self.photos.value.removeAll()
        self.query = query
        self.page = 1
        self.fetch()
    }
}
