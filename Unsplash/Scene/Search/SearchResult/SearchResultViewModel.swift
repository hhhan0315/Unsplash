//
//  SearchResultViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import Foundation

final class SearchResultViewModel {
    private let apiService: APIServiceProtocol
    
    private var photos: [Photo] = []
    private var page = 1
    private var query = ""
    
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
        apiService.request(api: .getSearchPhotos(query: self.query, page: self.page),
                           dataType: Search.self) { [weak self] result in
            switch result {
            case .success(let search):
                self?.photos.append(contentsOf: search.results)
                let cellViewModels = search.results.compactMap { self?.createCellViewModel(photo: $0) }
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
    
    func update(_ query: String) {
        guard self.query != query else {
            return
        }
        self.query = query
        self.page = 1
        photos.removeAll()
        cellViewModels.removeAll()
        fetch()
    }
    
    func reset() {
        self.query = ""
        self.page = 1
        photos.removeAll()
        cellViewModels.removeAll()
    }
}
