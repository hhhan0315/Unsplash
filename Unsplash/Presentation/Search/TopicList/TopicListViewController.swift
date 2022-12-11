//
//  TopicListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import Combine

final class TopicListViewController: UIViewController {
    
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
        collectionView.register(TopicListCollectionViewCell.self, forCellWithReuseIdentifier: TopicListCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: TopicListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    
    private enum Section {
        case topics
    }
    
    // MARK: - View LifeCycle
    
    init(viewModel: TopicListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        
        topicCollectionView.dataSource = dataSource
        topicCollectionView.delegate = self
        
        setupSearchController()
        setupViews()
        setupDataSource()
        bindViewModel()
        
        viewModel.viewDidLoad()
    }
    
    private func setupSearchController() {
        let searchResultViewController = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupTopicCollectionView()
    }
    
    private func setupTopicCollectionView() {
        view.addSubview(topicCollectionView)
        topicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topicCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topicCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topicCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DiffableDataSource
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicListCollectionViewCell.identifier, for: indexPath) as? TopicListCollectionViewCell else {
                return .init()
            }
            cell.topic = topic
            return cell
        })
    }
    
    private func applySnapshot(with topics: [Topic]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([Section.topics])
        snapShot.appendItems(topics)
        dataSource?.apply(snapShot)
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        viewModel.$topics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] topics in
                self?.applySnapshot(with: topics)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard errorMessage != nil else {
                    return
                }
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension TopicListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath)
    }
}
