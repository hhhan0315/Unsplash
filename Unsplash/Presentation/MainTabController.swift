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
        
        configureUI()
    }
    
    private func configureUI() {
        let homeTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.home.image, selectedImage: nil)
        let searchTabBarItem = UITabBarItem(title: nil, image: MainTabBarItem.search.image, selectedImage: nil)
                
        let networkService: Networkable = NetworkService()
        let homeViewModel = HomeViewModel(networkService: networkService)
        let homeViewController = UINavigationController(rootViewController: HomeViewController(viewModel: homeViewModel))
        homeViewController.tabBarItem = homeTabBarItem
        
        let searchViewModel = SearchViewModel(networkService: networkService)
        let searchViewController = UINavigationController(rootViewController: SearchViewController(viewModel: searchViewModel))
        searchViewController.tabBarItem = searchTabBarItem
        
        self.tabBar.tintColor = .white
        
        self.viewControllers = [homeViewController, searchViewController]
    }
}
