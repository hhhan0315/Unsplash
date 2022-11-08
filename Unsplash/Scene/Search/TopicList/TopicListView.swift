//
//  TopicListView.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol TopicListViewActionListener: AnyObject {
    func topicListDidTap(with topic: Topic)
}

final class TopicListView: UIView {
    
    // MARK: - View Define
    
    private let topicCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopicPhotoCollectionViewCell.self, forCellWithReuseIdentifier: TopicPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let dataSource = TopicListDataSource()
    private let delegate = TopicListDelegate()
    
    // MARK: - Internal Properties
    
    weak var listener: TopicListViewActionListener?
    
    var topics: [Topic] = [] {
        didSet {
            dataSource.topics = topics
            delegate.topics = topics
            
            DispatchQueue.main.async {
                self.topicCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topicCollectionView.dataSource = dataSource
        topicCollectionView.delegate = delegate
        
        setupTopicCollectionView()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupTopicCollectionView() {
        addSubview(topicCollectionView)
        topicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicCollectionView.topAnchor.constraint(equalTo: topAnchor),
            topicCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topicCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topicCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - User Action
    
    private func bindAction() {
        delegate.selectTopicClosure = { [weak self] selectedTopic in
            self?.listener?.topicListDidTap(with: selectedTopic)
        }
    }
}
