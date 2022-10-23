//
//  DetailCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/20.
//

import UIKit

final class DetailCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .detail
    
    var navigationController: UINavigationController
    
    var photo: Photo
        
    init(navigationController: UINavigationController, photo: Photo) {
        self.navigationController = navigationController
        self.photo = photo
    }
    
    func start() {
        let detailViewModel = DetailViewModel(photo: photo)
        detailViewModel.coordinator = self
        let detailViewController = DetailViewController(photo: photo, viewModel: detailViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(detailViewController, animated: true)
    }
    
    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
