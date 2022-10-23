//
//  TopicCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

final class TopicCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .topic
    
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        let topicViewModel = TopicViewModel()
        topicViewModel.coordinator = self
        let topicViewController = TopicViewController(viewModel: topicViewModel)
        navigationController.setViewControllers([topicViewController], animated: false)
    }
    
    func pushTopicDetail(with topic: Topic) {
        let topicDetailCoordinator = TopicDetailCoordinator(navigationController: navigationController, topic: topic)
        topicDetailCoordinator.finishDelegate = self
        topicDetailCoordinator.start()
        childCoordinators.append(topicDetailCoordinator)
    }
}

extension TopicCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
    }
}
