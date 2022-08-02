//
//  PhotoDetailCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/19.
//

import UIKit

class PhotoDetailCollectionViewCell: UICollectionViewCell {
    static let identifier: String = String(describing: PhotoDetailCollectionViewCell.self)
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
    }
    
//    func setImage(_ photo: Photo) {
//        self.photoImageView.image = photo.image
//    }
}

private extension PhotoDetailCollectionViewCell {
    func configure() {
        self.addViews()
        self.makeConstraints()
    }
    
    func addViews() {
        self.contentView.addSubview(self.photoImageView)
    }
    
    func makeConstraints() {
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
}
