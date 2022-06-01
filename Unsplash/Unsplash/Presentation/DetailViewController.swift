//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum Section {
        case photos
    }
    
    private lazy var photoCollectionView: UICollectionView = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (visibleItems, scrollOffset, layoutEnvironment) in
            visibleItems.forEach({ item in
                guard let photo = self.photoDataSource?.itemIdentifier(for: item.indexPath) else { return }
                self.navigationItem.title = photo.userName
            })
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: PhotoDetailCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    private var photos: [Photo]
    private var currentIndexPath: IndexPath
    
    init(photos: [Photo], indexPath: IndexPath) {
        self.photos = photos
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.photoCollectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
    }
}

// MARK: - Private Function

private extension DetailViewController {
    func configure() {
        self.configureUI()
        self.configurePhotoDataSource()
    }
    
    func configureUI() {
        self.view.addSubview(self.photoCollectionView)
        
        NSLayoutConstraint.activate([
            self.photoCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCollectionViewCell.identifier, for: indexPath) as? PhotoDetailCollectionViewCell else {
                return PhotoDetailCollectionViewCell()
            }
            cell.setImage(photo)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([Section.photos])
        snapshot.appendItems(self.photos)
        self.photoDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
