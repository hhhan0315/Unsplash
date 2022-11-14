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
    
    private var page = 0
    private var currentQuery = ""
        
    // MARK: - View LifeCycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        mainView.listener = self
    }
    
    // MARK: - Networking
    
    private func getSearchPhotos() {
        page += 1
        
        apiService.request(api: .getSearchPhotos(query: currentQuery, page: page),
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
    
    private func reset() {
        page = 0
        currentQuery = ""
        mainView.photos.removeAll()
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        
        guard currentQuery != query else {
            return
        }
        
        reset()
        currentQuery = query
        getSearchPhotos()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reset()
    }
}

// MARK: - PinterestPhotoListViewActionListener

extension SearchResultViewController: PinterestPhotoListViewActionListener {
    func pinterestPhotoListViewWillDisplayLast() {
        getSearchPhotos()
    }
    
    func pinterestPhotoListViewCellDidTap(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        present(photoDetailViewController, animated: true)
    }
}
