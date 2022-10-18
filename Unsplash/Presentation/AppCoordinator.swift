//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import UIKit

final class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(tabBarController: UITabBarController())
        mainCoordinator.start()
        children.append(mainCoordinator)
        
        window.rootViewController = mainCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
