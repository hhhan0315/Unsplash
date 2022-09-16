//
//  HomeTopicCollectionViewCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

protocol HomeTopicCollectionViewCellDelegate: AnyObject {
    func touchTopicButton(title: String)
}

class HomeTopicCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = String(describing: HomeTopicCollectionViewCell.self)
    
    weak var delegate: HomeTopicCollectionViewCellDelegate?
    
    // MARK: - UI Define
    
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configureCell(with topic: Topic) {
        titleButton.setTitle(topic.title, for: .normal)
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupTitleButton()
    }
    
    private func setupTitleButton() {
        contentView.addSubview(titleButton)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
        ])
    }
    
    // MARK: - Objc
    
    @objc private func touchUpButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
            return
        }
        delegate?.touchTopicButton(title: title)
    }
}
