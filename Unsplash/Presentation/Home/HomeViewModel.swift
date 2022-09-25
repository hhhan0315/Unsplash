//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

final class HomeViewModel {
    @Published var range: Range<Int>? = nil
    @Published var error: APIError? = nil
    
    private let photoService = PhotoService()
    var photos: [Photo] = []
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        let previousCount = photosCount()
        
        photoService.fetch { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
                self.range = previousCount..<self.photosCount()
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
