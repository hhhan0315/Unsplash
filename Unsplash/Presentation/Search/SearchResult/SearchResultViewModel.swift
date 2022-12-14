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
    func willDisplayLast()
}

protocol SearchResultViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class SearchResultViewModel: SearchResultViewModelInput, SearchResultViewModelOutput {
    private let photoSearchRepository: PhotoSearchRepository
    
    private var page = 0
    private var currentQuery = ""
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(photoSearchRepository: PhotoSearchRepository) {
        self.photoSearchRepository = photoSearchRepository
    }
    
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

// MARK: - Input

extension SearchResultViewModel {
    func didSearch(query: String) {
        guard currentQuery != query else {
            return
        }
        
        reset()
        currentQuery = query
        fetchSearchPhots()
    }
    
    func didSearchBarCancelButtonClick() {
        reset()
    }
    
    func willDisplayLast() {
        fetchSearchPhots()
    }
}
