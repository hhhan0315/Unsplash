//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import Foundation

class SearchViewModel {
    private let searchPhotoUseCase: SearchPhotoUseCase
    private(set) var photos: [Photo]
    private(set) var query: String
    private(set) var page: Int
    var onFetchPhotoTopicSuccess: (() -> Void)?
    var onFetchPhotoTopicFailure: ((Error) -> Void)?
    
    init(searchPhotoUseCase: SearchPhotoUseCase) {
        self.searchPhotoUseCase = searchPhotoUseCase
        self.photos = []
        self.query = ""
        self.page = 1
    }
    
    func fetch() {
        self.searchPhotoUseCase.fetch(query: self.query, page: self.page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                self?.page += 1
                self?.onFetchPhotoTopicSuccess?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(_ query: String) {
        guard self.query != query else { return }
        self.photos = []
        self.query = query
        self.page = 1
        self.fetch()
    }
}
