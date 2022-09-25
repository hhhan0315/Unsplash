//
//  PinterestDetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit

final class PinterestDetailViewController: UIViewController {
    
    // MARK: - UI Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.register(HomeTableViewCell.self, forCellWithReuseIdentifier: HomeTableViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Properties
    
//    private
    
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupPinterestLayout()
        setupPhotoCollectionView()
    }
    
    private func setupPinterestLayout() {
        let layout = PinterestLayout()
        layout.delegate = self
        
        photoCollectionView.collectionViewLayout = layout
    }
    
    private func setupPhotoCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension PinterestDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return .init()
    }
}

// MARK: - UICollectionViewDelegate

extension PinterestDetailViewController: UICollectionViewDelegate {
    
}

// MARK: - PinterestLayoutDelegate

extension PinterestDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
}
