//
//  PhotoDetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

final class PhotoDetailViewModel {
    
    @Published var photos: [Photo] = []
    @Published var indexPath: IndexPath?
    
    init(photos: [Photo], indexPath: IndexPath) {
        self.photos = photos
        self.indexPath = indexPath
    }
}
