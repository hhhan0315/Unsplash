//
//  TopicPhotoListViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import Foundation

protocol TopicPhotoListViewModelInput {
    func viewDidLoad(with slug: String)
    func willDisplayLast()
}

protocol TopicPhotoListViewModelOutput {
    var photos: [Photo] { get }
    var errorMessage: String? { get }
}

final class TopicPhotoListViewModel: TopicPhotoListViewModelInput, TopicPhotoListViewModelOutput {
    private let getTopicPhotoListUseCase: GetTopicPhotoListUseCase
    
    private var page = 0
    private var currentSlug = ""
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(getTopicPhotoListUseCase: GetTopicPhotoListUseCase) {
        self.getTopicPhotoListUseCase = getTopicPhotoListUseCase
    }
    
    private func fetchTopicPhotoList() {
        page += 1
        
        getTopicPhotoListUseCase.execute(slug: currentSlug, page: self.page) { [weak self] result in
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

extension TopicPhotoListViewModel {
    func viewDidLoad(with slug: String) {
        currentSlug = slug
        fetchTopicPhotoList()
    }
    
    func willDisplayLast() {
        fetchTopicPhotoList()
    }
}
