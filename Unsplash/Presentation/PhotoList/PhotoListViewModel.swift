//
//  PhotoListViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol PhotoListViewModelInput {
    func viewDidLoad()
    func didSelectItem(_ indexPath: IndexPath)
    func willDisplayLast()
}

protocol PhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class PhotoListViewModel: PhotoListViewModelInput, PhotoListViewModelOutput {
    private var page = 0
    
    private let photoRepository: PhotoRepository
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        fetchPhotoList()
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        // 코디네이터 전환
    }
    
    func willDisplayLast() {
        fetchPhotoList()
    }
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    private func fetchPhotoList() {
        self.page += 1
        
        photoRepository.fetchPhotoList(page: self.page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos += photos
            case .failure(let error):
                self?.errorMessage = error.rawValue
            }
        }
    }
}
