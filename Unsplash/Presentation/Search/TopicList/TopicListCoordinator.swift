//
//  TopicListCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import UIKit

protocol TopicListCoordinatorDelegate: AnyObject {
    func goToTopicPhotoList(with topic: Topic)
}

final class TopicListCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func start() {
        let networkService = NetworkService()
        let topicRepository = DefaultTopicRepository(networkService: networkService)
        let topicListViewModel = TopicListViewModel(topicRepository: topicRepository)
        topicListViewModel.coordinator = self
        
        let topicListViewController = TopicListViewController(viewModel: topicListViewModel)
        navigationController.setViewControllers([topicListViewController], animated: true)
    }
}

extension TopicListCoordinator: TopicListCoordinatorDelegate {
    func goToTopicPhotoList(with topic: Topic) {
        let topicPhotoListViewController = TopicPhotoListViewController(topic: topic)
        navigationController.pushViewController(topicPhotoListViewController, animated: true)
    }
}
