//
//  MainTabController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

final class MainTabController: UITabBarController {
    
    enum MainTabBarItem {
        case home
        case search
        case heart
        
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "photo.fill")
            case .search:
                return UIImage(systemName: "magnifyingglass")
            case .heart:
                return UIImage(systemName: "heart.fill")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        let homeTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.home.image, selectedImage: nil)
        let searchTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.search.image, selectedImage: nil)
        let heartTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.heart.image, selectedImage: nil)
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = homeTabBarItem
        
        let topicViewController = UINavigationController(rootViewController: TopicViewController())
        topicViewController.tabBarItem = searchTabBarItem
        
        let heartViewController = UINavigationController(rootViewController: HeartViewController())
        heartViewController.tabBarItem = heartTabBarItem
        
        self.tabBar.tintColor = .label
        
        self.viewControllers = [homeViewController, topicViewController, heartViewController]
    }
}
