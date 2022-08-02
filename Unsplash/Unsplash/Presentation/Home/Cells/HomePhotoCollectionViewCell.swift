//
//  HomePhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/08.
//

import UIKit

class HomePhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = String(describing: HomePhotoCollectionViewCell.self)
    
    // MARK: - UI Define
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel])
        stackView.axis = .horizontal
        stackView.backgroundColor = .black
        stackView.layer.opacity = 0.7
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return stackView
    }()
    
    // MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Layout
    private func setupViews() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bottomStackView)
    }
    
    private func makeConstraints() {
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Configure
    func configureCell(with photoResponse: PhotoResponse) {
        nameLabel.text = photoResponse.user.name
        ImageLoader.shared.load(photoResponse.urls.small) { data in
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        }
        
    }
}
