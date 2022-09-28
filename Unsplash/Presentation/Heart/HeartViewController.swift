//
//  HeartViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit

final class HeartViewController: UIViewController {
    
    // MARK: - UI Define
    
    // MARK: - Properties
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Likes"
    }
    
    // MARK: - Configure
    
    // MARK: - Bind

}
