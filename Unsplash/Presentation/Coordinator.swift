//
//  Coordinator.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    
    func start()
}
