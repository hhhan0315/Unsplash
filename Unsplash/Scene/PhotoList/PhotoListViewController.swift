//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    // MARK: - View Define
    
    private let mainView = PhotoListView()
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
    
    // MARK: - Internal Properties
    
    private var page = 0
    
    // MARK: - View LifeCycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Unsplash"
        
        mainView.listener = self
        
        getListPhotos()
    }
    
    // MARK: - Networking
    
    private func getListPhotos() {
        page += 1
        
        apiService.request(api: .getListPhotos(page: page), dataType: [Photo].self) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.mainView.photos += photos
            case .failure(let apiError):
                DispatchQueue.main.async {
                    self?.showAlert(message: apiError.errorDescription)
                }
            }
        }
    }
}

// MARK: - PhotoListViewActionListener

extension PhotoListViewController: PhotoListViewActionListener {
    func photoListViewWillDisplayLast() {
        getListPhotos()
    }
    
    func photoListViewCellDidTap(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        photoDetailViewController.modalPresentationStyle = .overFullScreen
        present(photoDetailViewController, animated: true)
    }
}
