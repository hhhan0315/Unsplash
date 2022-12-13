//
//  PhotoDetailCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/12/12.
//

import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: PhotoDetailCollectionViewCell.self)
    
    var photo: Photo? {
        didSet {
            photoImageView.downloadImage(with: photo)
        }
    }
        
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.image = nil
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoImageView()
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
