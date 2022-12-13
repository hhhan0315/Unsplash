//
//  PhotoDetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

protocol PhotoDetailViewModelInput {
    func willScroll(item: Int)
    func heartButtonDidTap(with indexPath: IndexPath)
}

protocol PhotoDetailViewModelOutput {
    var photos: [Photo] { get }
    var indexPath: IndexPath? { get }
    var heartButtonState: Bool { get }
}

final class PhotoDetailViewModel: PhotoDetailViewModelInput, PhotoDetailViewModelOutput {
    private let photoCoreDataRepository = DefaultPhotoCoreDataRepository()
    
    @Published var photos: [Photo] = []
    @Published var indexPath: IndexPath?
    @Published var heartButtonState: Bool = false
    
    init(photos: [Photo], indexPath: IndexPath) {
        self.photos = photos
        self.indexPath = indexPath
    }
}

// MARK: - Input

extension PhotoDetailViewModel {
    func willScroll(item: Int) {
        let photo = photos[item]
        Task {
            let state = try await photoCoreDataRepository.isExist(id: photo.id)
            heartButtonState = state
        }
    }
    
    func heartButtonDidTap(with indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        Task {
            if try await photoCoreDataRepository.isExist(id: photo.id) {
                try await photoCoreDataRepository.delete(id: photo.id)
                heartButtonState = false
            } else {
                try await photoCoreDataRepository.create(photo: photo)
                heartButtonState = true
            }
        }
    }
}
