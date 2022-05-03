//
//  TopicCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class TopicCell: UICollectionViewCell {
    static let identifier: String = String(describing: TopicCell.self)
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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

private extension TopicCell {
    func configure() {
        self.configureUI()
    }
    
    func configureUI() {
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
        ])
    }
}
