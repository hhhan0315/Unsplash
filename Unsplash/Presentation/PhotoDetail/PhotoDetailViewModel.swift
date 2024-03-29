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
    func actionButtonDidTap(with indexPath: IndexPath)
    func downloadButtonDidTap(with indexPath: IndexPath)
}

protocol PhotoDetailViewModelOutput {
    var photos: [Photo] { get }
    var indexPath: IndexPath? { get }
    var heartButtonState: Bool { get }
    var shareText: String? { get }
    var downloadDidSuccess: Bool? { get }
}

final class PhotoDetailViewModel: PhotoDetailViewModelInput, PhotoDetailViewModelOutput {
    private let photoCoreDataRepository = DefaultPhotoCoreDataRepository()
    private let imageSaveManager = ImageSaveManager()
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var indexPath: IndexPath?
    @Published var heartButtonState: Bool = false
    @Published var shareText: String?
    @Published var downloadDidSuccess: Bool?
    
    init(photos: [Photo], indexPath: IndexPath) {
        self.photos = photos
        self.indexPath = indexPath
        
        imageSaveManager.delegate = self
    }
}

// MARK: - Input

extension PhotoDetailViewModel {
    func willScroll(item: Int) {
        let photo = photos[item]
        heartButtonState = photoCoreDataRepository.isExist(id: photo.id)
    }
    
    func heartButtonDidTap(with indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        
        if photoCoreDataRepository.isExist(id: photo.id) {
            photoCoreDataRepository.delete(id: photo.id)
            heartButtonState = false
        } else {
            photoCoreDataRepository.create(photo: photo)
            heartButtonState = true
        }
    }
    
    func actionButtonDidTap(with indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        shareText = photo.links.html
    }
    
    func downloadButtonDidTap(with indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        imageSaveManager.writeToPhotoAlbum(with: photo.urls.regular)
    }
}

// MARK: - ImageSaveManagerDelegate

extension PhotoDetailViewModel: ImageSaveManagerDelegate {
    func imageSaveSuccess() {
        downloadDidSuccess = true
    }
    
    func imageSaveFailure() {
        downloadDidSuccess = false
    }
}
