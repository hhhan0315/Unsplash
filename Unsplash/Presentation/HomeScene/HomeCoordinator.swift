//
//  HomeCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func presentDetail(with photo: Photo)
}

final class HomeCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = .init()
    }
    
    func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.setViewControllers([homeViewController], animated: false)
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    func presentDetail(with photo: Photo) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, photo: photo)
        detailCoordinator.finishDelegate = self
        detailCoordinator.start()
        childCoordinators.append(detailCoordinator)
    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.dismiss(animated: true)
    }
}
