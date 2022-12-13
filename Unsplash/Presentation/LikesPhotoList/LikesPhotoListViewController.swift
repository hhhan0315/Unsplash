//
//  HeartPhotoListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit
import Combine

final class LikesPhotoListViewController: UIViewController {
    
    // MARK: - View Define

    private let photoCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LikesPhotoCollectionViewCell.self, forCellWithReuseIdentifier: LikesPhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: LikesPhotoListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private enum Section {
        case photos
    }
        
    // MARK: - View LifeCycle
    
    init(viewModel: LikesPhotoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Likes"
        
        photoCollectionView.delegate = self
        
        setupViews()
        setupDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoCollectionView()
    }

    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DiffableDataSource
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesPhotoCollectionViewCell.identifier, for: indexPath) as? LikesPhotoCollectionViewCell else {
                return .init()
            }
            cell.photo = photo
            return cell
        })
    }

    private func applySnapshot(with photos: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([Section.photos])
        snapShot.appendItems(photos)
        dataSource?.apply(snapShot)
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.applySnapshot(with: photos)
            }
            .store(in: &cancellables)
    }
}

extension LikesPhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailViewModel = PhotoDetailViewModel(photos: viewModel.photos, indexPath: indexPath)
        let photoDetailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
        photoDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
}
