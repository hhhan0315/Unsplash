//
//  PhotoListCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import UIKit

protocol PhotoListCoordinatorDelegate: AnyObject {
    func goToDetail(with photo: Photo)
}

final class PhotoListCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func start() {
        let networkService = NetworkService()
        let photoRespository = DefaultPhotoRepository(networkService: networkService)
        let photoListViewModel = PhotoListViewModel(photoRepository: photoRespository)
        photoListViewModel.coordinator = self
        
        let photoListViewController = PhotoListViewController(viewModel: photoListViewModel)
        navigationController.setViewControllers([photoListViewController], animated: false)
    }
}

extension PhotoListCoordinator: PhotoListCoordinatorDelegate {
    func goToDetail(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}
