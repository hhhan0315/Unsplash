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
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(touchUpButton(_:)), for: .touchUpInside)
        return button
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
    func configureCell(with topic: Topic) {
        button.setTitle(topic.title, for: .normal)
    }
    
    // MARK: - Layout
    private func configure() {
        self.addViews()
        self.makeConstraints()
    }
    
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
    
    // MARK: - Objc
    @objc private func touchUpButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
            return
        }
        delegate?.touchTopicButton(title: title)
    }
}
