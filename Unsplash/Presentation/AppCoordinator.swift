//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import UIKit

final class AppCoordinator: Coordinator {
    enum TabBarItem {
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
    
    var children: [Coordinator] = []
    var tabBarController = UITabBarController()
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let photoListTabBarItem = UITabBarItem(title: nil, image: TabBarItem.photoList.image, selectedImage: nil)
        let topicListTabBarItem = UITabBarItem(title: nil, image: TabBarItem.topicList.image, selectedImage: nil)
        let likesPhotoListTabBarItem = UITabBarItem(title: nil, image: TabBarItem.likesPhotoList.image, selectedImage: nil)
        
        let photoListCoordinator = PhotoListCoordinator()
        photoListCoordinator.navigationController.tabBarItem = photoListTabBarItem
        photoListCoordinator.start()
        children.append(photoListCoordinator)
        
        let topicListCoordinator = TopicListCoordinator()
        topicListCoordinator.navigationController.tabBarItem = topicListTabBarItem
        topicListCoordinator.start()
        children.append(topicListCoordinator)
        
        tabBarController.viewControllers = [
            photoListCoordinator.navigationController,
            topicListCoordinator.navigationController
        ]
        
        tabBarController.tabBar.tintColor = .label
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
