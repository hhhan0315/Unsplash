//
//  HeartCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

final class HeartCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .heart
    
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        let heartViewModel = HeartViewModel()
        heartViewModel.coordinator = self
        let heartViewController = HeartViewController(viewModel: heartViewModel)
        navigationController.setViewControllers([heartViewController], animated: false)
    }
    
    func presentDetail(with photo: Photo) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, photo: photo)
        detailCoordinator.finishDelegate = self
        detailCoordinator.start()
        childCoordinators.append(detailCoordinator)
    }
}

extension HeartCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.dismiss(animated: true)
    }
}
