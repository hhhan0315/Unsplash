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
        configureSearchController()
    }
    
    private func configureUI() {
        navigationItem.title = "Search"
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
}
