//
//  MainTabBarController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
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
        
        let photoListViewController = UINavigationController(rootViewController: PhotoListViewController())
        photoListViewController.tabBarItem = photoListTabBarItem
        
        let topicListViewController = UINavigationController(rootViewController: TopicListViewController())
        topicListViewController.tabBarItem = topicListTabBarItem
        
        let likesPhotoListViewController = UINavigationController(rootViewController: LikesPhotoListViewController())
        likesPhotoListViewController.tabBarItem = likesPhotoListTabBarItem
        
        self.tabBar.tintColor = .label
        
        self.viewControllers = [photoListViewController, topicListViewController, likesPhotoListViewController]
    }
}
