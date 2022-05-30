//
//  TopicCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    static let identifier: String = String(describing: TopicCollectionViewCell.self)
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TopicCollectionViewCell {
    func configure() {
        self.addViews()
        self.makeConstraints()
    }
    
    func addViews() {
        self.contentView.addSubview(self.button)
    }
    
    func makeConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
        ])
    }
}
