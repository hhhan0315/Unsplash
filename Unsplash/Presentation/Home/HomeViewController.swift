//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var topicCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.register(HomeTopicCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopicCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomePhotoTableViewCell.self, forCellReuseIdentifier: HomePhotoTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    // MARK: - View LifeCycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBind()
        viewModel.fetch()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupNavigation()
        setupTopicCollectionView()
        setupPhotoTableView()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Unsplash"
        navigationItem.backButtonTitle = ""
    }
    
    private func setupTopicCollectionView() {
        view.addSubview(topicCollectionView)
        topicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topicCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topicCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topicCollectionView.heightAnchor.constraint(equalToConstant: 60.0),
        ])
    }
    
    private func setupPhotoTableView() {
        view.addSubview(photoTableView)
        photoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoTableView.topAnchor.constraint(equalTo: topicCollectionView.bottomAnchor),
            photoTableView.leadingAnchor.constraint(equalTo: topicCollectionView.leadingAnchor),
            photoTableView.trailingAnchor.constraint(equalTo: topicCollectionView.trailingAnchor),
            photoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.fetchEnded = { [weak self] in
            DispatchQueue.main.async {
                self?.photoTableView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topicsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopicCollectionViewCell.identifier, for: indexPath) as? HomeTopicCollectionViewCell else {
            return .init()
        }
        
        let topic = viewModel.topic(at: indexPath.item)
        cell.configureCell(with: topic)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePhotoTableViewCell.identifier, for: indexPath) as? HomePhotoTableViewCell else {
            return .init()
        }
        
        let photoResponse = viewModel.photo(at: indexPath.row)
        cell.configureCell(with: photoResponse)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width
        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photos: viewModel.photos, indexPath: indexPath)
        detailViewController.modalPresentationStyle = .fullScreen
        present(detailViewController, animated: true)
    }
}

// MARK: - HomeTopicCollectionViewCellDelegate

extension HomeViewController: HomeTopicCollectionViewCellDelegate {
    func touchTopicButton(title: String) {
        guard let topic = Topic(rawValue: title.lowercased()) else {
            return
        }
        viewModel.update(with: topic)
    }
}
