//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
