//
//  SearchResultViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
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
    
    private let viewModel = SearchResultViewModel()
    
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
        setupPhotoCollectionView()
        setupPhotoDataSource()
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDelegate {
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

// MARK: - PinterestLayoutDelegate

extension SearchResultViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageHeight)
        let imageWidth = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageWidth)
        let imageRatio = imageHeight / imageWidth

        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItems() -> Int {
        return photoDataSource?.snapshot().numberOfItems ?? 0
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        photoCollectionView.setContentOffset(.zero, animated: false)
        viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reset()
    }
}
