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
    var children: [Coordinator] = []
    
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
        let detailViewController = DetailViewController(photo: photo)
        detailViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(detailViewController, animated: true)
    }
}
