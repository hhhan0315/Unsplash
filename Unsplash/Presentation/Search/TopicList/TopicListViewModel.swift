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
    var isLoading: Bool { get }
}

final class TopicListViewModel: TopicListViewModelInput, TopicListViewModelOutput {
    private let topicRepository: TopicRepository
    init(topicRepository: TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        fetchTopicList()
    }
    
    func didSelectItem(_ indexPath: IndexPath) {
        // 코디네이터 전환
    }
    
    // MARK: - Output
    
    @Published var topics: [Topic] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private func fetchTopicList() {
        self.isLoading = true
        
        topicRepository.fetchTopicList { [weak self] result in
            switch result {
            case .success(let topics):
                self?.topics += topics
            case .failure(let error):
                self?.errorMessage = error.rawValue
            }
            self?.isLoading = false
        }
    }
}
