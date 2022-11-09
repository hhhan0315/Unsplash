//
//  TopicListCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/09/23.
//

import UIKit

final class TopicListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TopicListCollectionViewCell.self)
    
    var topic: Topic? {
        didSet {
            titleLabel.text = topic?.title
            photoImageView.downloadImage(with: topic?.coverPhoto.urls.regular ?? "")
        }
    }
    
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.opacity = 0.3
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        return label
    }()
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        photoImageView.layer.cornerRadius = 10
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupPhotoImageView()
        setupBlackImageView()
        setupTitleLabel()
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
    
    private func setupBlackImageView() {
        contentView.addSubview(blackImageView)
        blackImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blackImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blackImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
