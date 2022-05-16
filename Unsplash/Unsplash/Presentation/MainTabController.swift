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
        
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "photo.fill")
            case .search:
                return UIImage(systemName: "magnifyingglass")
            }
        }
    }
    
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
        let homeTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.home.image, selectedImage: nil)
        let searchTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.search.image, selectedImage: nil)
                
        let networkSerivce = NetworkService()
        let defaultTopicPhotoRepository = DefaultTopicPhotoRepository(service: networkSerivce)
        
        let defaultTopicPhotoUseCase = DefaultTopicPhotoUseCase(topicPhotoRepository: defaultTopicPhotoRepository)
        
        let homeViewModel = HomeViewModel(topicPhotoUseCase: defaultTopicPhotoUseCase)
                
        let homeViewController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
        homeViewController.tabBarItem = homeTabBarItem
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = searchTabBarItem
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkGray
        
        self.viewControllers = [homeViewController, searchViewController]
    }
}
