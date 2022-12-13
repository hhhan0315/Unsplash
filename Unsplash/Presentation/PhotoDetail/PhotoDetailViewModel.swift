//
//  PhotoDetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

protocol PhotoDetailViewModelInput {
    func heartButtonDidTap(with indexPath: IndexPath)
}

protocol PhotoDetailViewModelOutput {
    var photos: [Photo] { get }
    var indexPath: IndexPath? { get }
}

final class PhotoDetailViewModel: PhotoDetailViewModelInput, PhotoDetailViewModelOutput {
    
    @Published var photos: [Photo] = []
    @Published var indexPath: IndexPath?
    
    init(photos: [Photo], indexPath: IndexPath) {
        self.photos = photos
        self.indexPath = indexPath
    }
}

// MARK: - Input

extension PhotoDetailViewModel {
    func heartButtonDidTap(with indexPath: IndexPath) {
        
    }
}
