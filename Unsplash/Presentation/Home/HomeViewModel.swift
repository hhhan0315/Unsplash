//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

final class HomeViewModel {
    private let apiService: APIServiceProtocol
    
    private var photos: [Photo] = []
    private var page = 1
    
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
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetch() {
        apiService.request(api: .getPhotos(page: page), dataType: [Photo].self) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                let cellViewModels = photos.compactMap { self?.createCellViewModel(photo: $0) }
                self?.cellViewModels.append(contentsOf: cellViewModels)
                self?.page += 1
            case .failure(let apiError):
                self?.alertMessage = apiError.errorDescription
            }
        }
    }
    
    func getCellViewModel(indexPath: IndexPath) -> PhotoCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    func createCellViewModel(photo: Photo) -> PhotoCellViewModel {
        return PhotoCellViewModel(id: photo.id,
                                  titleText: photo.user.name,
                                  imageURL: photo.urls.regular,
                                  imageWidth: photo.width,
                                  imageHeight: photo.height)
    }
}
