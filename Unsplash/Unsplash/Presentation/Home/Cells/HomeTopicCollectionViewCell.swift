//
//  HomeTopicCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class HomeTopicCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = String(describing: HomeTopicCollectionViewCell.self)
    
    // MARK: - UI Define
    private let button: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addViews()
        self.makeConstraints()
    }
    
    // MARK: - Layout
    private func addViews() {
        self.contentView.addSubview(self.button)
    }
    
    private func makeConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
        ])
    }
    
    // MARK: - Configure
    func configureCell(with topic: Topic) {
        button.setTitle(topic.title, for: .normal)
    }
}
