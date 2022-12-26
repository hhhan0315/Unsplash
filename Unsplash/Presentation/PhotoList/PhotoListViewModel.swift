//
//  PhotoListViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol PhotoListViewModelInput {
    func viewDidLoad()
    func willDisplayLast()
}

protocol PhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class PhotoListViewModel: PhotoListViewModelInput, PhotoListViewModelOutput {
    private let getPhotoListUseCase: GetPhotoListUseCase
    private var page = 0
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(getPhotoListUseCase: GetPhotoListUseCase) {
        self.getPhotoListUseCase = getPhotoListUseCase
    }
    
    private func fetchPhotoList() {
        self.page += 1
        
        getPhotoListUseCase.execute(page: self.page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos += photos
            case .failure(let networkError):
                self?.errorMessage = networkError.rawValue
            }
        }
    }
}

// MARK: - Input

extension PhotoListViewModel {
    func viewDidLoad() {
        fetchPhotoList()
    }
    
    func willDisplayLast() {
        fetchPhotoList()
    }
}
