//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

final class HomeViewModel {
    @Published var photos: [Photo] = []
    @Published var error: APIError? = nil
    
    private let photoService = PhotoService()
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        photoService.fetch { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
