//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    
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
    
    private let viewModel = SearchViewModel()
    
    private var cancellable = Set<AnyCancellable>()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    enum Section {
        case photos
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
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
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.configureCell(with: photo)
            return cell
        })
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(photos)
                self?.photoDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] apiError in
                guard let apiError = apiError else {
                    return
                }
                self?.showAlert(message: apiError.errorDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photo: viewModel.photo(at: indexPath.item))
        detailViewController.modalPresentationStyle = .fullScreen
        present(detailViewController, animated: true)
    }
}

// MARK: - PinterestLayoutDelegate

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth

        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItems() -> Int {
        return photoDataSource?.snapshot().numberOfItems ?? 0
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reset()
    }
}
