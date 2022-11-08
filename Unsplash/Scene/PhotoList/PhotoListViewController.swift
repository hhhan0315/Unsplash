//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    // MARK: - UI Define
    
    private let mainView = PhotoListView()
    
    // MARK: - Private Properties
    
    private let apiService = APIService()
    
    // MARK: - Internal Properties
    
    private var page = 0
    
    // MARK: - View LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Unsplash"
        
        getPhotos()
    }
    
    // MARK: - Networking
    
    private func getPhotos() {
        page += 1
        
        apiService.request(api: .getPhotos(page: self.page), dataType: [Photo].self) { [weak self] result in
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

// MARK: - UICollectionViewDelegate

//extension PhotoListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == viewModel.numberOfCells - 1 {
//            viewModel.fetch()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
//        let detailViewController = DetailViewController(photoCellViewModel: photoCellViewModel)
//        detailViewController.modalPresentationStyle = .overFullScreen
//        present(detailViewController, animated: true)
//    }
//}
