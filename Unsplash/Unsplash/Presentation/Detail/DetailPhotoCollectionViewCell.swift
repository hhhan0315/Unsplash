//
//  DetailPhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/19.
//

import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = String(describing: DetailPhotoCollectionViewCell.self)
    
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
    
    func configureCell(with photoResponse: PhotoResponse) {
        ImageLoader.shared.load(photoResponse.urls.small) { data in
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func configure() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(photoImageView)
    }
    
    private func makeConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
