//
//  TopicViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

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
        collectionView.register(TopicPhotoCollectionViewCell.self, forCellWithReuseIdentifier: TopicPhotoCollectionViewCell.identifier)
        collectionView.dataSource = topicDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    enum Section {
        case topic
    }
    
    private let viewModel = TopicViewModel()
    
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, TopicPhotoCellViewModel>?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
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
        let searchResultViewController = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.showsSearchResultsController = true
        
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
        topicDataSource = UICollectionViewDiffableDataSource(collectionView: topicCollectionView, cellProvider: { collectionView, indexPath, topicPhotoCellViewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicPhotoCollectionViewCell.identifier, for: indexPath) as? TopicPhotoCollectionViewCell else {
                return .init()
            }
            cell.topicPhotoCellViewModel = topicPhotoCellViewModel
            return cell
        })
    }
            
    // MARK: - Bind
    
    private func setupViewModel() {
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                var snapShot = NSDiffableDataSourceSnapshot<Section, TopicPhotoCellViewModel>()
                snapShot.appendSections([Section.topic])
                snapShot.appendItems(self?.viewModel.cellViewModels ?? [])
                self?.topicDataSource?.apply(snapShot)
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let alertMessage = self?.viewModel.alertMessage else {
                    return
                }
                self?.showAlert(message: alertMessage)
            }
        }
        
        viewModel.fetch()
    }
}

// MARK: - UICollectionViewDelegate

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topicPhotoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
        let topicDetailViewController = TopicDetailViewController(slug: topicPhotoCellViewModel.slug, title: topicPhotoCellViewModel.title)
        navigationController?.pushViewController(topicDetailViewController, animated: true)
    }
}
