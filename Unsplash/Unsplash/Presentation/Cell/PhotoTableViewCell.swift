//
//  PhotoCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/08.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: PhotoTableViewCell.self)
        
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
    
    func setImage(_ photoItem: Photo) {
        self.photoImageView.image = photoItem.image    
    }
}

private extension PhotoTableViewCell {
    func configure() {
        self.addSubviews()
        self.makeConstraints()
    }
    
    func addSubviews() {
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
