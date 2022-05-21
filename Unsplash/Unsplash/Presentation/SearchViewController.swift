//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum Section {
        case photos
    }
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: PhotoCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        
        self.viewModel.onFetchPhotoTopicSuccess = { [weak self] in
            DispatchQueue.main.async {
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(self?.viewModel.photos ?? [])
                self?.photoDataSource?.apply(snapShot)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyQuery = ""
        self.viewModel.update(emptyQuery)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCount = self.photoDataSource?.snapshot().numberOfItems else { return }
        guard indexPath.item >= itemCount - 1 else { return }
        self.viewModel.fetch()
    }
}

// MARK: - Private Functions

private extension SearchViewController {
    func configure() {
        self.configureUI()
        self.configureDelegate()
        self.configureSearchController()
        self.configurePhotoDataSource()
        self.configurePhotoCollectionViewLayout()
    }
    
    func configureUI() {
        self.navigationItem.title = "Search"
        
        self.view.addSubview(self.photoCollectionView)

        NSLayoutConstraint.activate([
            self.photoCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureDelegate() {
        self.photoCollectionView.delegate = self
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                return PhotoCell()
            }
            cell.setImage(indexPath, photo: photo)
            return cell
        })
    }
    
    func configurePhotoCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(488)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(488)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        self.photoCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
