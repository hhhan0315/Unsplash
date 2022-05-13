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
        
        self.configure()
    }
}

private extension MainTabController {
    func configure() {
        self.configureUI()
    }
    
    func configureUI() {
        let homeViewModel = HomeViewModel(networkService: NetworkService())
        let homeVC = self.configureTemplateNavigationController(unselectedImage: UIImage(systemName: "photo.fill"), selectedImage: UIImage(systemName: "photo.fill"), rootViewController: HomeViewController(viewModel: homeViewModel))
        
        let searchVC = self.configureTemplateNavigationController(unselectedImage: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"), rootViewController: SearchViewController())
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkGray
        
        self.viewControllers = [homeVC, searchVC]
    }
    
    func configureTemplateNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
}
