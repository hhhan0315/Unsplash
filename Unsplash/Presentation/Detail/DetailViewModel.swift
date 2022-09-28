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
    
    private var photo: Photo
    
    private let imageFileManager = ImageFileManager()
    private let imageLoader = ImageLoader()
    private let coreDataManager = CoreDataManager()
    
    init(photo: Photo) {
        self.photo = photo
        fetchHeartSelected()
    }
    
    func fetchHeartSelected() {
        imageFileManager.existImageInFile(id: photo.id) { isExist in
            self.isHeartSelected = isExist ? true : false
        }
    }
    
    func fetchPhotoLike() {
        imageFileManager.existImageInFile(id: photo.id) { isExist in
            if isExist {
                self.deleteFileManagerImage()
            } else {
                self.imageLoader.load(with: self.photo.url) { data in
                    self.saveFileManagerImage(data)
                }
            }
        }
    }
    
    private func deleteFileManagerImage() {
        self.imageFileManager.deleteImage(id: self.photo.id) { result in
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
        self.coreDataManager.deletePhotoCoreData(photo: self.photo) { result in
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
        self.imageFileManager.saveImage(id: self.photo.id, data: data) { result in
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
        self.coreDataManager.savePhotoCoreData(photo: self.photo) { result in
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
}
