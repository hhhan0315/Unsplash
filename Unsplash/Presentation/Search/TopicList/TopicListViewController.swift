//
//  TopicListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

final class TopicListViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = TopicListView()
    
    // MARK: - Private Properties
    
//    private let apiService = APIService()
    
    // MARK: - View LifeCycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        setupSearchController()
        
        mainView.listener = self
        
        getListTopics()
    }
    
    private func setupSearchController() {
        let searchResultViewController = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // MARK: - Networking
    
    private func getListTopics() {
//        apiService.request(api: .getListTopics, dataType: [Topic].self) { [weak self] result in
//            switch result {
//            case .success(let topics):
//                self?.mainView.topics += topics
//            case .failure(let apiError):
//                DispatchQueue.main.async {
//                    self?.showAlert(message: apiError.rawValue)
//                }
//            }
//        }
    }
}

// MARK: - TopicListViewActionListener

extension TopicListViewController: TopicListViewActionListener {
    func topicListDidTap(with topic: Topic) {
        let topicPhotoListViewController = TopicPhotoListViewController(topic: topic)
        navigationController?.pushViewController(topicPhotoListViewController, animated: true)
    }
}
