//
//  SearchPhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/31.
//

import UIKit

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = String(describing: SearchPhotoCollectionViewCell.self)
    
    private let imageLoader = ImageLoader()
    
    // MARK: - UI Define
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()
    
    // MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configureCell(with photoResponse: PhotoResponse) {
        nameLabel.text = photoResponse.user.name
        imageLoader.load(photoResponse.urls.small) { data in
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - Layout
    private func configure() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func makeConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8.0),
        ])
    }
}
