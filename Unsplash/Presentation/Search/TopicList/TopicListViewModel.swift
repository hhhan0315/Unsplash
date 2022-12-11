//
//  TopicListViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import Foundation

protocol TopicListViewModelInput {
    func viewDidLoad()
    func didSelectItem(_ indexPath: IndexPath)
}

protocol TopicListViewModelOutput {
    var topics: [Topic] { get }
    var errorMessage: String? { get }
}

final class TopicListViewModel: TopicListViewModelInput, TopicListViewModelOutput {
    private let topicRepository: TopicRepository
    
    weak var coordinator: TopicListCoordinatorDelegate?
    
    // MARK: - Output
    
    @Published var topics: [Topic] = []
    @Published var errorMessage: String?
    
    init(topicRepository: TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    private func fetchTopicList() {
        topicRepository.fetchTopicList { [weak self] result in
            switch result {
            case .success(let topics):
                self?.topics += topics
            case .failure(let networkError):
                self?.errorMessage = networkError.rawValue
            }
        }
    }
}

// MARK: - Input

extension TopicListViewModel {
    func viewDidLoad() {
        fetchTopicList()
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        let topic = topics[indexPath.item]
        coordinator?.goToTopicPhotoList(with: topic)
    }
}
