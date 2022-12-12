//
//  SearchResultViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import UIKit
import Combine

final class SearchResultViewController: UIViewController {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: SearchResultViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
        
    private enum Section {
        case photos
    }
    
    // MARK: - View LifeCycle
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = self
        
        setupViews()
        setupPhotoDataSource()
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPinterestLayout()
        setupPhotoCollectionView()
    }
    
    private func setupPinterestLayout() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        
        photoCollectionView.collectionViewLayout = pinterestLayout
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
    
    // MARK: - DiffableDataSource
    
    private func setupPhotoDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.photo = photo
            return cell
        })
    }
    
    private func applySnapshot(with photos: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([Section.photos])
        snapShot.appendItems(photos)
        dataSource?.apply(snapShot)
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                if photos.isEmpty {
                    self?.photoCollectionView.setContentOffset(.zero, animated: false)
                }
                
                self?.applySnapshot(with: photos)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard errorMessage != nil else {
                    return
                }
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        
        viewModel.didSearch(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didSearchBarCancelButtonClick()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 1 {
            viewModel.willDisplayLast()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.item]
        let photoDetailViewController = PhotoDetailViewController(photo: photo)
//        photoDetailViewController.hidesBottomBarWhenPushed = true
        present(photoDetailViewController, animated: true)
//        navigationController?.pushViewController(photoDetailViewController, animated: true)
//        navigationController?.present(photoDetailViewController, animated: true)
    }
}

// MARK: - PinterestLayoutDelegate

extension SearchResultViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = UIScreen.main.bounds.width / 2
        let imageHeight = viewModel.photos[indexPath.item].height
        let imageWidth = viewModel.photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItemsInCollectionView() -> Int {
        return dataSource?.snapshot().numberOfItems ?? 0
    }
}
