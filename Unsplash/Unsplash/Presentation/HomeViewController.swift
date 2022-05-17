//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum Section {
        case topics
        case photos
    }
    
    private let topicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: PhotoCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.identifier)
        return collectionView
    }()
    
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        
        self.viewModel.fetch()
        
        self.viewModel.onFetchPhotoTopicSuccess = { [weak self] in
            DispatchQueue.main.async {
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(self?.viewModel.photos ?? [])
                self?.photoDataSource?.apply(snapShot)
            }
        }
    }
    
    @objc func touchTopicButton(_ sender: UIButton) {
        guard let title = sender.currentTitle, let topic = Topic(rawValue: title.lowercased()) else { return }
        self.viewModel.update(topic)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCount = self.photoDataSource?.snapshot().numberOfItems else { return }
        guard indexPath.item >= itemCount - 1 else { return }
        self.viewModel.fetch()
    }
}

private extension HomeViewController {
    func configure() {
        self.configureUI()
        self.configureDelegate()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
        self.configurePhotoCollectionViewLayout()
    }
    
    func configureUI() {
        self.navigationItem.title = "Unsplash"
        
        self.view.addSubview(self.topicCollectionView)
        self.view.addSubview(self.photoCollectionView)
        
        NSLayoutConstraint.activate([
            self.topicCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.topicCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.topicCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.topicCollectionView.heightAnchor.constraint(equalToConstant: 60.0),
            
            self.photoCollectionView.topAnchor.constraint(equalTo: self.topicCollectionView.bottomAnchor),
            self.photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureDelegate() {
        self.photoCollectionView.delegate = self
    }
    
    func configureTopicDataSource() {
        self.topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: self.topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else {
                return TopicCell()
            }
            cell.button.setTitle(topic.title, for: .normal)
            cell.button.addTarget(self, action: #selector(self.touchTopicButton(_:)), for: .touchUpInside)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([.topics])
        snapShot.appendItems(Topic.allCases, toSection: .topics)
        self.topicDataSource?.apply(snapShot)
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
                return PhotoCell()
            }
            cell.setImage(indexPath, photo: photo)
            return cell
        })
    }
    
    func configurePhotoCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        self.photoCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
