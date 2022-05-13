//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

class HomeViewModel {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var photos: [Photo] = []
    var onFetchPhotoTopicSuccess: (() -> Void)?
    var onFetchPhotoTopicFailure: ((Error) -> Void)?
    
    func fetch() {
        let request = PhotoTopicRequest()
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.onFetchPhotoTopicSuccess?()
            case .failure(let error):
                self?.onFetchPhotoTopicFailure?(error)
            }
        }
    }
}
