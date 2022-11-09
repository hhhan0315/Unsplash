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
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Unsplash"
        
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

extension PhotoListViewController: PhotoListViewActionListener {
    func photoListDidTap(with photo: Photo) {
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
        photoDetailViewController.modalPresentationStyle = .overFullScreen
        present(photoDetailViewController, animated: true)
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
