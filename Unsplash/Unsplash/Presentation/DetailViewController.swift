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
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: PhotoDetailCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoDetailCell.identifier)
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
    
    // 레이아웃 결정 후 뷰 위치 크기 조정, 데이터 reload, 뷰 컨텐츠 업데이트
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.photoCollectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
        guard let photo = self.photoDataSource?.itemIdentifier(for: self.currentIndexPath) else { return }
        self.navigationItem.title = photo.user.name
    }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photo = self.photoDataSource?.itemIdentifier(for: indexPath) else { return }
        self.navigationItem.title = photo.user.name
    }
}

// MARK: - Private Function

private extension DetailViewController {
    func configure() {
        self.configureUI()
        self.configureDelegate()
        self.configurePhotoDataSource()
        self.configurePhotoCollectionViewLayout()
    }
    
    func configureUI() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(touchLeftBarButton))
        leftBarButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.view.addSubview(self.photoCollectionView)
        
        NSLayoutConstraint.activate([
            self.photoCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func touchLeftBarButton() {
        self.dismiss(animated: false)
    }
    
    func configureDelegate() {
        self.photoCollectionView.delegate = self
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCell.identifier, for: indexPath) as? PhotoDetailCell else {
                return PhotoDetailCell()
            }
            cell.setImage(indexPath, photo: photo)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([Section.photos])
        snapshot.appendItems(self.photos)
        self.photoDataSource?.apply(snapshot)
    }
    
    func configurePhotoCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        self.photoCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
