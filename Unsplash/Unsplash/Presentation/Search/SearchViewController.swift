//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    // MARK: - View Define
    private lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout(numberOfColumns: 2)
        layout.delegate = self
        return layout
    }()
    
    // MARK: - Properties
    enum Section {
        case photo
    }
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoResponse>?
    
    private let viewModel: SearchViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - View LifeCycle
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupPhotoDataSource()
        setupBind()
    }
    
    // MARK: - Layout
    private func setupViews() {
        setupNavigation()
        addSubviews()
        makeConstraints()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Search"
        navigationItem.backButtonTitle = ""
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addSubviews() {
        view.addSubview(photoCollectionView)
    }
    
    private func makeConstraints() {
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DataSource
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoResponse>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoResponse in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCollectionViewCell.identifier, for: indexPath) as? SearchPhotoCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(with: photoResponse)
            return cell
        })
    }
    
    // MARK: - Bind
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoResponse>()
                snapShot.appendSections([Section.photo])
                snapShot.appendItems(photos)
                self.pinterestLayout.update(numberOfItems: snapShot.numberOfItems)
                self.photoDataSource?.apply(snapShot, animatingDifferences: false)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyQuery = ""
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        viewModel.update(emptyQuery)
    }
}

// MARK: - PinterestLayoutDelegate
extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2 // 셀 가로 크기
        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
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
        guard let photos = photoDataSource?.snapshot().itemIdentifiers else {
            return
        }
        let detailViewController = DetailViewController(photos: photos, indexPath: indexPath)
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
