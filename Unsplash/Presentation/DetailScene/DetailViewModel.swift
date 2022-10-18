//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation

final class DetailViewModel {
    var isHeartSelected: Bool? {
        didSet {
            showHeartButtonStateClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var showHeartButtonStateClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    
//    private var photoCellViewModel: PhotoCellViewModel
    private var photo: Photo
    
//    private let imageLoader = ImageLoader()
    private let coreDataManager = CoreDataManager()
    
//    init(photoCellViewModel: PhotoCellViewModel) {
//        self.photoCellViewModel = photoCellViewModel
//    }
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func fetchHeartSelected() {
        coreDataManager.isExistPhotoCoreData(id: photo.id) { [weak self] result in
            switch result {
            case .success(let isExist):
                self?.isHeartSelected = isExist ? true : false
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func fetchPhotoLike() {
        coreDataManager.isExistPhotoCoreData(id: photo.id) { [weak self] result in
            switch result {
            case .success(let isExist):
                if isExist {
                    self?.deletePhotoCoreData()
                } else {
                    self?.savePhotoCoreData()
                }
                self?.postNotificationHeart()
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
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
                self.alertMessage = error.localizedDescription
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
                self.alertMessage = error.localizedDescription
            }
        }
    }
    
    private func postNotificationHeart() {
        NotificationCenter.default.post(name: Notification.Name.heartButtonClicked, object: nil)
    }
}
