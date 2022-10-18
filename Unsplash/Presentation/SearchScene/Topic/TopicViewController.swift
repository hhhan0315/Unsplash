//
//  TopicViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TopicViewController: UIViewController {
    
    // MARK: - UI Define
    
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
    
    // MARK: - Properties
    
    private let viewModel: TopicViewModel
    private var disposeBag = DisposeBag()
        
    // MARK: - View LifeCycle
    
    init(viewModel: TopicViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchController()
        setupTopicCollectionView()
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
        topicCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
            
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = TopicViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            didSelectItemEvent: topicCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.topics
            .observe(on: MainScheduler.instance)
            .bind(to: topicCollectionView.rx.items(cellIdentifier: TopicPhotoCollectionViewCell.identifier, cellType: TopicPhotoCollectionViewCell.self)) { index, topic, cell in
                cell.configureCell(with: topic)
            }
            .disposed(by: disposeBag)
        
        output.alertMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alertMessage in
                self?.showAlert(message: alertMessage)
            })
            .disposed(by: disposeBag)
    }
}
