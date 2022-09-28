//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation

final class DetailViewModel {
    @Published var isHeartSelected: Bool = false
    
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
                self.imageFileManager.deleteImage(id: self.photo.id)
                self.coreDataManager.deletePhotoCoreData(photo: self.photo) { _ in
                    self.isHeartSelected = false
                }
            } else {
                self.imageLoader.load(with: self.photo.url) { data in
                    self.imageFileManager.saveImage(id: self.photo.id, data: data)
                    self.coreDataManager.savePhotoCoreData(photo: self.photo)
                    self.isHeartSelected = true
                }
            }
        }
    }
}
