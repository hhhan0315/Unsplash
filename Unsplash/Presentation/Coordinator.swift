//
//  Coordinator.swift
//  Unsplash
//
//  Created by rae on 2022/12/10.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
//    var navigationController: UINavigationController { get set }
    func start()
}
