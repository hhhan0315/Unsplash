//
//  SearchViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum Section {
        case photos
    }
    
    private let photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var photoDataSource: UITableViewDiffableDataSource<Section, Photo>?
    
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let emptyQuery = ""
        self.viewModel.update(emptyQuery)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight {
            self.viewModel.fetch()
        }
    }
}

// MARK: - Private Functions

private extension SearchViewController {
    func configure() {
        self.configureUI()
        self.configureDelegate()
        self.configureSearchController()
        self.configurePhotoDataSource()
        self.bind(to: self.viewModel)
    }
    
    func configureUI() {
        self.navigationItem.title = "Search"
        
        self.view.addSubview(self.photoTableView)

        NSLayoutConstraint.activate([
            self.photoTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.photoTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.photoTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.photoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureDelegate() {
        self.photoTableView.delegate = self
    }
    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photos"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UITableViewDiffableDataSource<Section, Photo>(tableView: self.photoTableView, cellProvider: { tableView, indexPath, photoItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
                return PhotoTableViewCell()
            }
            cell.setImage(photoItem)
            return cell
        })
    }
    
    func bind(to viewModel: SearchViewModel) {
        viewModel.photos.observe(on: self) { [weak self] photos in
            var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapShot.appendSections([Section.photos])
            snapShot.appendItems(photos)
            self?.photoDataSource?.apply(snapShot, animatingDifferences: false)
        }
    }
}
