//
//  PhotoListView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol PhotoListViewActionListener: AnyObject {
    func photoListViewWillDisplayLast()
    func photoListViewCellDidTap(with photo: Photo)
}

final class PhotoListView: UIView {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
//    private let infoLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No photos"
//        return label
//    }()
    
    // MARK: - Private Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    private let delegate = PhotoListDeleagte()
    
    // MARK: - Internal Properties
    
    enum Section {
        case photos
    }
    
    weak var listener: PhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {
            delegate.photos = photos
            
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot()
//                self.infoLabel.isHidden = self.photos.isEmpty ? false : true
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        delegate.listener = self
        
        setupViews()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoCollectionView()
//        setupInfoLabel()
    }
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
//    private func setupInfoLabel() {
//        addSubview(infoLabel)
//        infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ])
//    }
    
    // MARK: - DiffableDataSource
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
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

// MARK: - PhotoListDelegateActionListener

extension PhotoListView: PhotoListDelegateActionListener {
    func willDisplayLast() {
        listener?.photoListViewWillDisplayLast()
    }
    
    func didSelect(with photo: Photo) {
        listener?.photoListViewCellDidTap(with: photo)
    }
}
