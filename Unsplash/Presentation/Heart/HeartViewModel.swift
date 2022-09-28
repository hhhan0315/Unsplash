//
//  HeartViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation

final class HeartViewModel {
    @Published var photos: [Photo] = []
    @Published var error: Error? = nil
    
    private let coreDataManager = CoreDataManager()
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        coreDataManager.fetchPhotoCoreData { result in
            switch result {
            case .success(let photoCoreData):
                let photos = photoCoreData.map {
                    Photo(id: $0.id ?? "",
                          width: Int($0.width),
                          height: Int($0.height),
                          url: $0.url ?? "",
                          user: $0.user ?? "")
                }
                self.photos = photos
            case .failure(let error):
                self.error = error
            }
        }
    }
}
