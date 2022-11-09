//
//  PhotoListView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol PhotoListViewActionListener: AnyObject {
    func willDisplayLastPhoto()
    func photoCollectionViewCellDidTap(with photo: Photo)
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
    
//    enum Section {
//        case photos
//    }
//
//    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    // MARK: - Private Properties
    
    private let dataSource = PhotoListDataSource()
    private let delegate = PhotoListDeleagte()
    
    // MARK: - Internal Properties
    
    weak var listener: PhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        didSet {
            dataSource.photos = photos
            delegate.photos = photos
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
//            setupSnapShot()
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        setupPhotoCollectionView()
        bindAction()
//        setupPhotoDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
//    private func setupPhotoDataSource() {
//        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
//                return .init()
//            }
//            cell.photo = photo
//            return cell
//        })
//    }
//
//    private func setupSnapShot() {
//        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
//        snapShot.appendSections([Section.photos])
//        snapShot.appendItems(self.photos)
//        self.dataSource?.apply(snapShot)
//    }
    
    // MARK: - User Action
    
    private func bindAction() {
        delegate.willDisplayClosure = { [weak self] in
            self?.listener?.willDisplayLastPhoto()
        }
        
        delegate.selectPhotoClosure = { [weak self] selectedPhoto in
            self?.listener?.photoCollectionViewCellDidTap(with: selectedPhoto)
        }
    }
}
