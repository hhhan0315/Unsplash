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
    private var state: ViewModelState
    
    init(searchPhotoUseCase: SearchPhotoUseCase) {
        self.searchPhotoUseCase = searchPhotoUseCase
        self.photos = Observable([])
        self.query = ""
        self.page = 1
        self.state = .ready
    }
    
    func fetch() {
        guard self.state == .ready else { return }
        self.state = .loading
        
        self.searchPhotoUseCase.fetch(query: self.query, page: self.page) { [weak self] result in
            switch result {
            case .success(let photoResponseDTOs):
                guard !photoResponseDTOs.isEmpty else {
                    self?.state = .ready
                    return
                }
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
