//
//  MainTabController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        let homeVC = configureTemplateNavigationController(unselectedImage: UIImage(systemName: "photo.fill"), selectedImage: UIImage(systemName: "photo.fill"), rootViewController: HomeViewController())
        let searchVC = configureTemplateNavigationController(unselectedImage: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"), rootViewController: SearchViewController())
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkGray
        
        self.viewControllers = [homeVC, searchVC]
    }
    
    private func configureTemplateNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
}
