//
//  LikesPhotoListCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/12/11.
//

import UIKit

protocol LikesPhotoListCoordinatorDelegate: AnyObject {
    func goToDetail(with photo: Photo)
}

final class LikesPhotoListCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func start() {
//        let networkService = NetworkService()
//        let photoRespository = DefaultPhotoRepository(networkService: networkService)
//        let photoListViewModel = PhotoListViewModel(photoRepository: photoRespository)
//        let photoListViewController = PhotoListViewController(viewModel: photoListViewModel)
//        photoListViewModel.coordinator = self
//        navigationController.setViewControllers([photoListViewController], animated: false)
    }
}

extension LikesPhotoListCoordinator: LikesPhotoListCoordinatorDelegate {
    func goToDetail(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}
