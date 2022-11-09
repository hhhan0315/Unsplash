//
//  SearchResultViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = PinterestPhotoListView()
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
        
    // MARK: - View LifeCycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        
        apiService.request(api: .getSearchPhotos(query: query, page: 1),
                           dataType: Search.self) { [weak self] result in
            switch result {
            case .success(let search):
                self?.mainView.photos += search.results
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self?.showAlert(message: apiError.errorDescription)
                }
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainView.photos.removeAll()
    }
}
