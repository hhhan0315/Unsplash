//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit
import Combine

final class PhotoDetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: PhotoDetailCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(heartButtonDidTap(_:)), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        return button
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: PhotoDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private enum Section {
        case photos
    }
        
    // MARK: - View LifeCycle
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.collectionViewLayout = setupPhotoCollectionViewLayout()
        
        setupViews()
        setupDataSource()
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoCollectionView()
        setupHeartButton()
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupHeartButton() {
        view.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.widthAnchor.constraint(equalToConstant: 60.0),
            heartButton.heightAnchor.constraint(equalToConstant: 60.0),
            heartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0),
            heartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
        ])
    }
    
    private func setupPhotoCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, environment) in
            let width = environment.container.contentSize.width
            let position = round(offset.x / width)
            self?.navigationItem.title = self?.viewModel.photos[Int(position)].user.name
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - DiffableDataSource
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCollectionViewCell.identifier, for: indexPath) as? PhotoDetailCollectionViewCell else {
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
        
        viewModel.$indexPath
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let indexPath = indexPath else {
                    return
                }
                self?.photoCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Button User Action
    
    @objc private func heartButtonDidTap(_ sender: UIButton) {
        guard let indexPath = photoCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        viewModel.heartButtonDidTap(with: indexPath)
    }
    
    // MARK: - NotificationCenter
    
//    private func postNotificationHeart() {
//        NotificationCenter.default.post(name: Notification.Name.heartButtonClicked, object: nil)
//    }
    
//    private func heartButtonDidTap() {
//        defer {
//            postNotificationHeart()
//        }
//
//        if coreDataManager.isExistPhotoData(photo: photo) {
//            coreDataManager.deletePhotoData(photo: photo) {
//                self.mainView.heartButtonToggle(state: false)
//            }
//        } else {
//            coreDataManager.insertPhotoData(photo: photo) {
//                self.mainView.heartButtonToggle(state: true)
//            }
//        }
//    }
}

// MARK: - PhotoDetailViewActionListener

//extension PhotoDetailViewController: PhotoDetailViewActionListener {
//    func photoDetailViewExitButtonDidTap() {
//        dismiss(animated: true)
//    }
//
//    func photoDetailViewHeartButtonDidTap(with photo: Photo) {
//        heartButtonDidTap()
//    }
//
//    func photoDetailViewImageViewDidDoubleTap() {
//        heartButtonDidTap()
//    }
//}
