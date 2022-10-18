//
//  MainCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/18.
//

import UIKit

final class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "photo.fill"), selectedImage: nil)
        let searchTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        let heartTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), selectedImage: nil)
        
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        homeCoordinator.navigationController.tabBarItem = homeTabBarItem
        homeCoordinator.start()
        children.append(homeCoordinator)
        
        let topicCoordinator = TopicCoordinator(navigationController: UINavigationController())
        topicCoordinator.navigationController.tabBarItem = searchTabBarItem
        topicCoordinator.start()
        children.append(topicCoordinator)
        
        tabBarController.setViewControllers([
            homeCoordinator.navigationController,
            topicCoordinator.navigationController
        ], animated: false)
    }
}
