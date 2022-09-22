//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

final class HomeViewModel {
    private let photoService = PhotoService()
    
    @Published var range: Range<Int>? = nil
    @Published var error: APIError? = nil
    
    private var photos: [Photo] = []
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        let count = self.photosCount()
        
        photoService.fetch { result in
            switch result {
            case .success(let photos):
                self.photos.append(contentsOf: photos)
                self.range = count..<count + Query.perPage
            case .failure(let apiError):
                self.error = apiError
            }
        }
    }
}
