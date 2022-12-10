//
//  SearchResultViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol SearchResultViewModelInput {
    func didSearch(query: String)
    func didSearchBarCancelButtonClick()
    func didSelectItem(_ indexPath: IndexPath)
    func willDisplayLast()
}

protocol SearchResultViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class SearchResultViewModel: SearchResultViewModelInput, SearchResultViewModelOutput {
    private var page = 0
    private var currentQuery = ""
    private let photoSearchRepository: PhotoSearchRepository
    
    init(photoSearchRepository: PhotoSearchRepository) {
        self.photoSearchRepository = photoSearchRepository
    }
    
    // MARK: - Input
    
    func didSearch(query: String) {
        guard currentQuery != query else {
            return
        }
        currentQuery = query
        fetchSearchPhots()
    }
    
    func didSearchBarCancelButtonClick() {
        reset()
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        // 코디네이터 패턴
    }
    
    func willDisplayLast() {
        fetchSearchPhots()
    }
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    private func fetchSearchPhots() {
        page += 1
        
        photoSearchRepository.fetchSearchPhotos(query: currentQuery, page: page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos += photos
            case .failure(let networkError):
                self?.errorMessage = networkError.rawValue
            }
        }
    }
    
    private func reset() {
        page = 0
        currentQuery = ""
        photos.removeAll()
    }
}
