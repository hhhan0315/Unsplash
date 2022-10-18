//
//  TopicCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

protocol TopicCoordinatorDelegate: AnyObject {
    func pushTopicDetail(with: Topic)
}

final class TopicCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let topicViewModel = TopicViewModel()
        topicViewModel.coordinator = self
        let topicViewController = TopicViewController(viewModel: topicViewModel)
        navigationController.setViewControllers([topicViewController], animated: false)
    }
}

extension TopicCoordinator: TopicCoordinatorDelegate {
    func pushTopicDetail(with: Topic) {
        print(#function)
    }
}
