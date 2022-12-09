//
//  LikesPhotoListView.swift
//  Unsplash
//
//  Created by rae on 2022/12/07.
//

import UIKit

protocol LikesPhotoListViewActionListener: AnyObject {
    func likesPhotoListViewCellDidTap(with photo: Photo)
}

final class LikesPhotoListView: UIView {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LikesPhotoCollectionViewCell.self, forCellWithReuseIdentifier: LikesPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    private let delegate = PhotoListDeleagte()
    
    // MARK: - Internal Properties
    
    enum Section {
        case photos
    }
    
    weak var listener: LikesPhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {
            delegate.photos = photos
            
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot()
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        delegate.listener = self
        
        setupPhotoCollectionView()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DiffableDataSource
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesPhotoCollectionViewCell.identifier, for: indexPath) as? LikesPhotoCollectionViewCell else {
                return .init()
            }
            cell.photo = photo
            return cell
        })
    }

    private func applySnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([Section.photos])
        snapShot.appendItems(photos)
        dataSource?.apply(snapShot)
    }
}

extension LikesPhotoListView: PhotoListDelegateActionListener {
    func willDisplayLast() {
        
    }
    
    func didSelect(with photo: Photo) {
        listener?.likesPhotoListViewCellDidTap(with: photo)
    }
}
