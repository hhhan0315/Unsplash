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
    private let topicPhotoRepository: TopicPhotoRepository
    
    private var page = 0
    private var currentSlug = ""
    
    // MARK: - Output
    
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?
    
    init(topicPhotoRepository: TopicPhotoRepository) {
        self.topicPhotoRepository = topicPhotoRepository
    }
    
    private func fetchTopicPhotoList() {
        page += 1
        
        topicPhotoRepository.fetchTopicPhotoList(slug: currentSlug, page: page) { [weak self] result in
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
