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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
//        collectionView.showsVerticalScrollIndicator = false
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
        viewModel.fetch()
        
        viewModel.onFetchPhotoTopicSuccess = { [weak self] in
            var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapShot.appendSections([Section.photos])
            snapShot.appendItems(self?.viewModel.photos ?? [])
            self?.photoDataSource?.apply(snapShot)
            print(self?.viewModel.photos.count)
        }
    }
    
    @objc func touchTopicButton(_ sender: UIButton) {
//        guard let title = sender.currentTitle, let topic = Topic(rawValue: title) else { return }
        
        // 뷰모델에서 topic에 따른 메소드 실행
    }
}

private extension HomeViewController {
    func configure() {
        self.configureUI()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
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
    
    func configureTopicDataSource() {
        self.topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: self.topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else {
                return TopicCell()
            }
            cell.button.setTitle(topic.rawValue, for: .normal)
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
        
//        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
//        snapShot.appendSections([Section.photos])
//        snapShot.appendItems(viewModel.photos)
//        self.photoDataSource?.apply(snapShot)
    }
}
