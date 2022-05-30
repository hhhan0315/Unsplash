//
//  PhotoCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/08.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    static let identifier: String = String(describing: PhotoTableViewCell.self)
        
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    func set(_ photoItem: Photo) {
        self.photoImageView.image = photoItem.image
        self.nameLabel.text = photoItem.userName
    }
}

private extension PhotoTableViewCell {
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
            
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -16.0),
        ])
    }
}
