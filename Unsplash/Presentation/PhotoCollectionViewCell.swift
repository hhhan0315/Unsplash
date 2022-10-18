//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit
import Kingfisher
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = String(describing: PhotoCollectionViewCell.self)
        
    // MARK: - View Define
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
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
        photoImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(contentView)
        }
    }
    
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.trailing.equalTo(contentView)
        }
    }
    
    // MARK: - Configure
    
    func configureCell(with photo: Photo) {
        nameLabel.text = photo.user.name
        guard let url = URL(string: photo.urls.regular) else {
            return
        }
        photoImageView.kf.setImage(with: url)
    }
}
