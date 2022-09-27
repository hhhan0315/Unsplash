//
//  TopicViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import Combine

final class TopicViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var topicCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        collectionView.dataSource = topicDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel = TopicViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    
    enum Section {
        case topic
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
        
        viewModel.fetch()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchController()
        setupTopicCollectionView()
        setupTopicDataSource()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Search"
    }
    
    private func setupSearchController() {
        let searchViewController = SearchViewController()
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchBar.delegate = searchViewController
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
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
    
    private func setupTopicDataSource() {
        topicDataSource = UICollectionViewDiffableDataSource(collectionView: topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as? TopicCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(with: topic)
            return cell
        })
    }
            
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$topics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] topics in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
                snapShot.appendSections([Section.topic])
                snapShot.appendItems(topics)
                self?.topicDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] apiError in
                guard let apiError = apiError else {
                    return
                }
                self?.showAlert(message: apiError.errorDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = viewModel.topic(at: indexPath.item)
        let pinterestDetailViewController = PinterestDetailViewController(slug: topic.slug, title: topic.title)
        navigationController?.pushViewController(pinterestDetailViewController, animated: true)
    }
}
