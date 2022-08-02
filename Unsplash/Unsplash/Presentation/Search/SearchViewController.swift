//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = PinterestLayout(numberOfColumns: 2)
//        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
//    private var photos: [Photo]
    
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
//        self.photos = []
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        self.viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyQuery = ""
        self.photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        self.viewModel.update(emptyQuery)
    }
}

// MARK: - PinterestLayoutDelegate

//extension SearchViewController: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let cellWidth: CGFloat = (view.bounds.width - 4) / 2 // 셀 가로 크기
//        guard let imageHeight = self.photos[indexPath.item].image?.size.height else { return 0 }
//        guard let imageWidth = self.photos[indexPath.item].image?.size.width else { return 0 }
//        let imageRatio = imageHeight / imageWidth
        
//        return CGFloat(imageRatio) * cellWidth
//    }
//}

// MARK: - UICollectionViewDataSource

//extension SearchViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.photos.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
//            return PhotoCollectionViewCell()
//        }
//
//        cell.set(photos[indexPath.row])
//        return cell
//    }
//}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let photoCount = self.photos.count
//        guard indexPath.item >= photoCount - 1 else { return }
//        self.viewModel.fetch()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailViewController = DetailViewController(photos: self.viewModel.photos.value, indexPath: indexPath)
//        self.navigationController?.pushViewController(detailViewController, animated: true)
//    }
}

// MARK: - Private Functions

private extension SearchViewController {
    func configure() {
        self.configureUI()
//        self.configureDelegate()
//        self.configureDataSource()
        self.configureSearchController()
//        self.bind(to: self.viewModel)
    }
    
    func configureUI() {
        self.navigationItem.title = "Search"
        self.navigationItem.backButtonTitle = ""
        
        self.view.addSubview(self.photoCollectionView)

        NSLayoutConstraint.activate([
            self.photoCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
//    func configureDelegate() {
//        self.photoCollectionView.delegate = self
//    }
//
//    func configureDataSource() {
//        self.photoCollectionView.dataSource = self
//    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
//    func bind(to viewModel: SearchViewModel) {
//        viewModel.photos.observe(on: self) { [weak self] photos in
//            self?.photos = photos
//            self?.photoCollectionView.reloadData()
//            self?.photoCollectionView.collectionViewLayout.invalidateLayout()
//        }
//    }
}
