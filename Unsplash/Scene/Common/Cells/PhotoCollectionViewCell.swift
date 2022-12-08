//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    var photo: Photo? {
        didSet {
            nameLabel.text = photo?.user.name
            photoImageView.downloadImage(with: photo)
        }
    }
        
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = BlackGradientImageView(frame: .zero)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
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
        nameLabel.text = nil
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoImageView()
        setupNameLabel()
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
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
        ])
    }
}
