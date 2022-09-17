//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit

class SearchViewModel {
    private var photos: [Photo]
    private var query: String
    private var page: Int
    private let searchService: SearchService
    
    private var updating: Bool
    
    var fetchEnded: () -> Void = {}
    var updateEnded: () -> Void = {}
    
    init() {
        self.photos  = []
        self.query = ""
        self.page = 1
        self.searchService = SearchService()
        self.updating = false
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetch() {
        searchService.fetch(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                self?.page += 1
                self?.fetchEnded()
                
                if self?.updating == true {
                    self?.updateEnded()
                    self?.updating = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func update(_ query: String) {
        guard self.query != query else {
            return
        }
        self.query = query
        photos.removeAll()
        page = 1
        updating = true
        fetch()
    }
}
