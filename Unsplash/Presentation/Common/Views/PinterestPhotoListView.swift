//
//  PinterestPhotoListView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol PinterestPhotoListViewActionListener: AnyObject {
    func pinterestPhotoListViewWillDisplayLast()
    func pinterestPhotoListViewCellDidTap(with photo: Photo)
}

final class PinterestPhotoListView: UIView {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
    
    weak var listener: PinterestPhotoListViewActionListener?
    
    var photos: [Photo] = [] {
        willSet {
            guard photos.isEmpty else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.photoCollectionView.setContentOffset(.zero, animated: false)
            }
        }
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
        
        setupViews()
        setupPhotoDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPinterestLayout()
        setupPhotoCollectionView()
    }
    
    private func setupPinterestLayout() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        
        photoCollectionView.collectionViewLayout = pinterestLayout
    }
    
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
    
    private func setupPhotoDataSource() {
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

// MARK: - PinterestLayoutDelegate

extension PinterestPhotoListView: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = UIScreen.main.bounds.width / 2
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItemsInCollectionView() -> Int {
        return dataSource?.snapshot().numberOfItems ?? 0
    }
}

// MARK: - PhotoListDelegateActionListener

extension PinterestPhotoListView: PhotoListDelegateActionListener {
    func willDisplayLast() {
        listener?.pinterestPhotoListViewWillDisplayLast()
    }
    
    func didSelect(with photo: Photo) {
        listener?.pinterestPhotoListViewCellDidTap(with: photo)
    }
}
