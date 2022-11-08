//
//  HeartViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/28.
//

import Foundation

final class HeartViewModel {
    private let coreDataManager = CoreDataManager()
    
    private var photos: [Photo] = []
    
    var cellViewModels: [PhotoCellViewModel] = [] {
        didSet {
            reloadCollectionViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadCollectionViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    
    func fetch() {
        coreDataManager.fetchPhotoCoreData { [weak self] result in
            switch result {
            case .success(let photoCoreData):
                let cellViewModels = photoCoreData.compactMap { self?.createCellViewModel(photoCoreData: $0) }
                self?.cellViewModels = cellViewModels
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
            }
        }
    }
    
    func getCellViewModel(indexPath: IndexPath) -> PhotoCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    func createCellViewModel(photoCoreData: PhotoCoreData) -> PhotoCellViewModel {
        return PhotoCellViewModel(id: photoCoreData.id ?? "",
                                  titleText: photoCoreData.user ?? "",
                                  imageURL: photoCoreData.url ?? "",
                                  imageWidth: CGFloat(photoCoreData.width),
                                  imageHeight: CGFloat(photoCoreData.height))
    }
}
