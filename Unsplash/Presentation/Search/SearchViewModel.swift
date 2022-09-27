//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import Foundation

final class SearchViewModel {
    @Published var photos: [Photo] = []
    @Published var error: APIError? = nil
    
    private let searchService = SearchService()
    private var currentQuery = ""
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        searchService.fetch(query: currentQuery) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
            case .failure(let apiError):
                self?.error = apiError
            }
        }
    }
    
    func update(_ query: String) {
        guard currentQuery != query else {
            return
        }
        currentQuery = query
        photos.removeAll()
        searchService.resetPage()
        fetch()
    }
    
    func reset() {
        currentQuery = ""
        photos.removeAll()
        searchService.resetPage()
    }
}
