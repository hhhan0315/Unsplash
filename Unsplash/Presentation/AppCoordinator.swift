//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import UIKit

final class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        children.append(mainCoordinator)
        
        window.rootViewController = mainCoordinator.tabBarController
    }
}
