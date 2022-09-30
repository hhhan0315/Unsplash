//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation

final class DetailViewModel {
    @Published var isHeartSelected: Bool = false
    @Published var error: Error? = nil
    
    private var photoCellViewModel: PhotoCellViewModel
    
    private let imageFileManager = ImageFileManager()
    private let imageLoader = ImageLoader()
    private let coreDataManager = CoreDataManager()
    
    init(photoCellViewModel: PhotoCellViewModel) {
        self.photoCellViewModel = photoCellViewModel
        fetchHeartSelected()
    }
    
    func fetchHeartSelected() {
        imageFileManager.existImageInFile(id: photoCellViewModel.id) { isExist in
            self.isHeartSelected = isExist ? true : false
        }
    }
    
    func fetchPhotoLike() {
        imageFileManager.existImageInFile(id: photoCellViewModel.id) { isExist in
            if isExist {
                self.deleteFileManagerImage()
                self.postNotificationHeart()
            } else {
                self.imageLoader.load(with: self.photoCellViewModel.imageURL) { data in
                    self.saveFileManagerImage(data)
                    self.postNotificationHeart()
                }
            }
        }
    }
    
    private func deleteFileManagerImage() {
        self.imageFileManager.deleteImage(id: self.photoCellViewModel.id) { result in
            switch result {
            case .success(let success):
                if success {
                    self.deletePhotoCoreData()
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func deletePhotoCoreData() {
        self.coreDataManager.deletePhotoCoreData(photoCellViewModel: self.photoCellViewModel) { result in
            switch result {
            case .success(let success):
                if success {
                    self.isHeartSelected = false
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func saveFileManagerImage(_ data: Data) {
        self.imageFileManager.saveImage(id: self.photoCellViewModel.id, data: data) { result in
            switch result {
            case .success(let success):
                if success {
                    self.savePhotoCoreData()
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func savePhotoCoreData() {
        self.coreDataManager.savePhotoCoreData(photoCellViewModel: self.photoCellViewModel) { result in
            switch result {
            case .success(let success):
                if success {
                    self.isHeartSelected = true
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func postNotificationHeart() {
        NotificationCenter.default.post(name: Notification.Name.heartButtonClicked, object: nil)
    }
}
