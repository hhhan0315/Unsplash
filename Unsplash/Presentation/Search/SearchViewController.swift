//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    
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
        return collectionView
    }()
    
//    private lazy var photoCollectionView: UICollectionView = {
//        let layout = PinterestLayout()
//        layout.delegate = self
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }()
    
    // MARK: - Properties
    
    private let viewModel = SearchViewModel()
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
//        setupPhotoCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Search"
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
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
    
//    private func setupPhotoCollectionView() {
//        view.addSubview(photoCollectionView)
//        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//    }
            
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$topics
            .receive(on: DispatchQueue.main)
            .sink { topics in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
                snapShot.appendSections([Section.topic])
                snapShot.appendItems(topics)
                self.topicDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { apiError in
                guard let apiError = apiError else {
                    return
                }
                self.showAlert(message: apiError.errorDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyQuery = ""
        viewModel.update(emptyQuery)
    }
}

// MARK: - PinterestLayoutDelegate

//extension SearchViewController: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let cellWidth: CGFloat = view.bounds.width / 2
//        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
//        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
//        let imageRatio = imageHeight / imageWidth
//
//        return CGFloat(imageRatio) * cellWidth
//    }
//}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = viewModel.topic(at: indexPath.item)
        let pinterestDetailViewController = PinterestDetailViewController(slug: topic.slug, title: topic.title)
        navigationController?.pushViewController(pinterestDetailViewController, animated: true)
    }
}
