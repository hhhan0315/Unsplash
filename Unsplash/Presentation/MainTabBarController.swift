//
//  MainTabBarController.swift
//  Unsplash
//
//  Created by rae on 2022/12/12.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    enum MainTabBarItem {
        case photoList
        case topicList
        case likesPhotoList
        
        var image: UIImage? {
            switch self {
            case .photoList:
                return UIImage(systemName: "photo.fill")
            case .topicList:
                return UIImage(systemName: "magnifyingglass")
            case .likesPhotoList:
                return UIImage(systemName: "heart.fill")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        let photoListTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.photoList.image, selectedImage: nil)
        let topicListTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.topicList.image, selectedImage: nil)
        let likesPhotoListTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.likesPhotoList.image, selectedImage: nil)
        
        let networkService = NetworkService()
        let photoRepository = DefaultPhotoRepository(networkService: networkService)
        let photoListViewModel = PhotoListViewModel(photoRepository: photoRepository)
        let photoListViewController = UINavigationController(rootViewController: PhotoListViewController(viewModel: photoListViewModel))
        photoListViewController.tabBarItem = photoListTabBarItem
        
        let topicRepository = DefaultTopicRepository(networkService: networkService)
        let topicListViewModel = TopicListViewModel(topicRepository: topicRepository)
        let topicListViewController = UINavigationController(rootViewController: TopicListViewController(viewModel: topicListViewModel))
        topicListViewController.tabBarItem = topicListTabBarItem
        
        let likesPhotoListViewController = UINavigationController(rootViewController: LikesPhotoListViewController())
        likesPhotoListViewController.tabBarItem = likesPhotoListTabBarItem
        
        self.tabBar.tintColor = .label
        
        self.viewControllers = [photoListViewController, topicListViewController, likesPhotoListViewController]
    }
}
