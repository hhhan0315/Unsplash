//
//  TopicPhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/09/23.
//

import UIKit
import SnapKit
import Kingfisher

final class TopicPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = String(describing: TopicPhotoCollectionViewCell.self)
    
    // MARK: - UI Define
    
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
        photoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        }
    }
    
    private func setupBlackImageView() {
        contentView.addSubview(blackImageView)
        blackImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        }
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(contentView)
        }
    }
    
    // MARK: - Configure
    
    func configureCell(with topic: Topic) {
        titleLabel.text = topic.title
        guard let url = URL(string: topic.coverPhoto.urls.regular) else {
            return
        }
        photoImageView.kf.setImage(with: url)
    }
}
