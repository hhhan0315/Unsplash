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
    private let photoRepository: PhotoRepository
    
    private var page = 0
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    private func fetchPhotoList() {
        self.page += 1
        
        photoRepository.fetchPhotoList(page: self.page) { [weak self] result in
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
