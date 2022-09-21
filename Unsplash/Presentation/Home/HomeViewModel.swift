//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

final class HomeViewModel {
    private let photoService = PhotoService()
    
    var photos: [Photo] = []
    
    var fetchSucceed: (() -> Void)?
    var fetchFail: ((APIError) -> Void)?
    
    func fetch() {
        photoService.fetch { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
                self.fetchSucceed?()
            case .failure(let apiError):
                self.fetchFail?(apiError)
            }
        }
    }
}
