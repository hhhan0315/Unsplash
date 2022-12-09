//
//  LikesPhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/12/09.
//

import UIKit

final class LikesPhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: LikesPhotoCollectionViewCell.self)
    
    var photo: Photo? {
        didSet {
            photoImageView.downloadImage(with: photo)
        }
    }
        
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = BlackGradientImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
