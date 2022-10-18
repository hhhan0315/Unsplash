//
//  TopicDetailCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

protocol TopicDetailCoordinatorDelegate: AnyObject {
    func presentDetail(with photo: Photo)
}

final class TopicDetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var topic: Topic
    
    init(navigationController: UINavigationController, topic: Topic) {
        self.navigationController = navigationController
        self.topic = topic
    }
    
    func start() {
        let topicDetailViewModel = TopicDetailViewModel(topic: topic)
        topicDetailViewModel.coordinator = self
        let topicDetailViewController = TopicDetailViewController(topic: topic, viewModel: topicDetailViewModel)
        navigationController.pushViewController(topicDetailViewController, animated: true)
    }
}

extension TopicDetailCoordinator: TopicDetailCoordinatorDelegate {
    func presentDetail(with photo: Photo) {
        let detailViewController = DetailViewController(photo: photo)
        detailViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(detailViewController, animated: true)
    }
}
