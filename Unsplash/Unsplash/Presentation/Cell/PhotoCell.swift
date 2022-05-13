//
//  PhotoCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/08.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifier: String = String(describing: PhotoCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ indexPath: IndexPath, photo: Photo) {
//        guard let url = URL(string: photo.urls.small) else { return }
        ImageClient.shared.setImage(from: photo.urls.thumb, placeholder: nil) { [weak self] image in
            self?.imageView.image = image
        }
    }
}

private extension PhotoCell {
    func configure() {
        self.configureUI()
    }
    
    func configureUI() {
        self.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
//            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
