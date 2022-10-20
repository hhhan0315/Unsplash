//
//  HeartCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

protocol HeartCoordinatorDelegate: AnyObject {
    func presentDetail(with photo: Photo)
}

final class HeartCoordinator: Coordinator {
    var children: [Coordinator] = []
    
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
}

extension HeartCoordinator: HeartCoordinatorDelegate {
    func presentDetail(with photo: Photo) {
        let detailViewController = DetailViewController(photo: photo)
        detailViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(detailViewController, animated: true)
    }
}
