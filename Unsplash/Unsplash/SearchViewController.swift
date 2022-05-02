//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "Search"
        
        view.backgroundColor = .black
    }
}
