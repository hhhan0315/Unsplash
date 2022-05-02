//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "Unsplash"
        
        view.backgroundColor = .black
    }
}
