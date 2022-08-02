//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/31.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = String(describing: PhotoCollectionViewCell.self)
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
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
        self.nameLabel.text = nil
    }
    
    func set(_ photo: PhotoResponse) {
//        self.photoImageView.image = photo.image
//        self.nameLabel.text = photo.userName
    }
}

private extension PhotoCollectionViewCell {
    func configure() {
        self.addSubviews()
        self.makeConstraints()
    }
    
    func addSubviews() {
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.nameLabel)
    }
    
    func makeConstraints() {
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -8.0),
        ])
    }
}
