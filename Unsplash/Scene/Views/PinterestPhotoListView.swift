//
//  PinterestPhotoListView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class PinterestPhotoListView: UIView {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let dataSource = PhotoListDataSource()
    private let delegate = PhotoListDeleagte()
    
    // MARK: - Internal Properties
    
    var photos: [Photo] = [] {
        didSet {
            dataSource.photos = photos
            delegate.photos = photos
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = delegate
        
        setupPinterestLayout()
        setupPhotoCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupPinterestLayout() {
        let layout = PinterestLayout()
        layout.delegate = self
        
        photoCollectionView.collectionViewLayout = layout
    }
    
    private func setupPhotoCollectionView() {
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension PinterestPhotoListView: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = UIScreen.main.bounds.width / 2
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
    }
}
