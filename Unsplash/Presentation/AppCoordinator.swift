//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import UIKit

final class AppCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var type: CoordinatorType = .app
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = .init()
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
        
        window.rootViewController = mainCoordinator.tabBarController
    }
}
