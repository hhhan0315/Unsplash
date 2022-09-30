//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    enum Section {
        case photos
    }
    
    private let viewModel = HomeViewModel()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoCellViewModel>?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
        setupPhotoDataSource()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoCellViewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.photoCellViewModel = photoCellViewModel
            return cell
        })
    }
    
    // MARK: - Bind
    
    private func setupViewModel() {
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoCellViewModel>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(self?.viewModel.cellViewModels ?? [])
                self?.photoDataSource?.apply(snapShot)
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let alertMessage = self?.viewModel.alertMessage else {
                    return
                }
                self?.showAlert(title: alertMessage)
            }
        }
        
        viewModel.fetch()
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.numberOfCells - 1 {
            viewModel.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
        let detailViewController = DetailViewController(photoCellViewModel: photoCellViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        present(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let imageHeight = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageHeight)
        let imageWidth = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageWidth)
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
