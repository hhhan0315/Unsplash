//
//  TopicDetailCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

final class TopicDetailCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .topicDetail
    
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
    
    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func presentDetail(with photo: Photo) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, photo: photo)
        detailCoordinator.finishDelegate = self
        detailCoordinator.start()
        childCoordinators.append(detailCoordinator)
    }
}

extension TopicDetailCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.dismiss(animated: true)
    }
}
