//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/05/17.
//

import UIKit
import Combine

class SearchViewModel {
    @Published var photos: [PhotoResponse]
    private var query: String
    private var page: Int
    private let networkService: Networkable
    
    init(networkService: Networkable) {
        self.photos  = []
        self.query = ""
        self.page = 1
        self.networkService = networkService
    }
    
    func photosCount() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> PhotoResponse {
        return photos[index]
    }
    
    func fetch() {
        let request = SearchPhotoRequest(query: query, page: page)
        networkService.request(request) { (result: Result<SearchResponse, NetworkError>) in
            switch result {
            case .success(let searchResponse):
                self.photos.append(contentsOf: searchResponse.results)
                self.page += 1
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
        fetch()
    }
}
