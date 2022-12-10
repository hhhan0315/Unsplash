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
}

protocol PhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
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
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private func fetchPhotoList() {
        self.page += 1
        self.isLoading = true
        
        photoRepository.fetchPhotoList(page: self.page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos += photos
            case .failure(let error):
                self?.errorMessage = error.rawValue
            }
            self?.isLoading = false
        }
    }
}
