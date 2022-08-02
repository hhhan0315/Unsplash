//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - View Define
    private lazy var photoCollectionView: UICollectionView = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (visibleItems, scrollOffset, layoutEnvironment) in
            visibleItems.forEach({ item in
                guard let photoResponse = self.photoDataSource?.itemIdentifier(for: item.indexPath) else { return }
                self.navigationItem.title = photoResponse.user.name
            })
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Properties
    enum Section {
        case photo
    }
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoResponse>?
    private var photos: [PhotoResponse]
    private var currentIndexPath: IndexPath
    
    // MARK: - View LifeCycle
    init(photos: [PhotoResponse], indexPath: IndexPath) {
        self.photos = photos
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - Layout
    private func setViews() {
        configureUI()
        configurePhotoDataSource()
    }
    
    private func configureUI() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configurePhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoResponse>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoResponse in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as? DetailPhotoCollectionViewCell else {
                return DetailPhotoCollectionViewCell()
            }
            cell.configureCell(with: photoResponse)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoResponse>()
        snapshot.appendSections([Section.photo])
        snapshot.appendItems(self.photos)
        self.photoDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
