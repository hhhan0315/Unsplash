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
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    private var photoDataSource: UITableViewDiffableDataSource<Section, Photo>?
    
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
    }
    
    @objc func touchTopicButton(_ sender: UIButton) {
        guard let title = sender.currentTitle, let topic = Topic(rawValue: title.lowercased()) else { return }
        self.viewModel.update(topic)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight {
            self.viewModel.fetch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photos: self.viewModel.photos.value, indexPath: indexPath)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - Private Function

private extension HomeViewController {
    func configure() {
        self.configureUI()
        self.configureDelegate()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
        self.bind(to: self.viewModel)
    }
    
    func configureUI() {
        self.navigationItem.title = "Unsplash"
        self.navigationItem.backButtonTitle = ""
        
        self.view.addSubview(self.topicCollectionView)
        self.view.addSubview(self.photoTableView)
        
        NSLayoutConstraint.activate([
            self.topicCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.topicCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.topicCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.topicCollectionView.heightAnchor.constraint(equalToConstant: 60.0),
            
            self.photoTableView.topAnchor.constraint(equalTo: self.topicCollectionView.bottomAnchor),
            self.photoTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureDelegate() {
        self.photoTableView.delegate = self
    }
    
    func configureTopicDataSource() {
        self.topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: self.topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as? TopicCollectionViewCell else {
                return TopicCollectionViewCell()
            }
            cell.button.setTitle(topic.title, for: .normal)
            cell.button.addTarget(self, action: #selector(self.touchTopicButton(_:)), for: .touchUpInside)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([Section.topics])
        snapShot.appendItems(Topic.allCases)
        self.topicDataSource?.apply(snapShot)
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: self.photoTableView, cellProvider: { tableView, indexPath, photoItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return PhotoTableViewCell()
            }
            cell.set(photoItem)
            return cell
        })
    }
    
    func bind(to viewModel: HomeViewModel) {
        viewModel.photos.observe(on: self) { [weak self] photos in
            var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapShot.appendSections([Section.photos])
            snapShot.appendItems(photos)
            self?.photoDataSource?.apply(snapShot, animatingDifferences: false)
        }
    }
}
