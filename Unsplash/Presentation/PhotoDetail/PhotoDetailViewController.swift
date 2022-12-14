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
        button.setPreferredSymbolConfiguration(.init(pointSize: 24.0, weight: .semibold), forImageIn: .normal)
        button.addTarget(self, action: #selector(heartButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.setPreferredSymbolConfiguration(.init(pointSize: 24.0, weight: .semibold), forImageIn: .normal)
        button.addTarget(self, action: #selector(downloadButtonDidTap(_:)), for: .touchUpInside)
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
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonDidTap(_:)))
        
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
        setupDownloadButton()
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
    
    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 60.0),
            downloadButton.heightAnchor.constraint(equalToConstant: 60.0),
            downloadButton.bottomAnchor.constraint(equalTo: heartButton.topAnchor, constant: -16.0),
            downloadButton.trailingAnchor.constraint(equalTo: heartButton.trailingAnchor),
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
            self?.viewModel.willScroll(item: Int(position))
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
        
        viewModel.$heartButtonState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartButtonState in
                self?.heartButton.tintColor = heartButtonState ? .red : .systemBackground
            }
            .store(in: &cancellables)
        
        viewModel.$shareText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shareText in
                guard let shareText = shareText else {
                    return
                }
                
                let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                self?.present(activityViewController, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$downloadDidSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadDidSuccess in
                guard let downloadDidSuccess = downloadDidSuccess else {
                    return
                }
                
                if downloadDidSuccess {
                    self?.showAlert(title: "저장 성공")
                } else {
                    self?.showPhotoSettingAlert()
                }
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
    
    @objc private func actionButtonDidTap(_ sender: UIBarButtonItem) {
        guard let indexPath = photoCollectionView.indexPathsForVisibleItems.first else {
            return
        }
        viewModel.actionButtonDidTap(with: indexPath)
    }
    
    @objc private func downloadButtonDidTap(_ sender: UIButton) {
        showAlert(title: "사진 저장", message: "앨범에 사진을 저장하시겠습니까?") { [weak self] _ in
            guard let indexPath = self?.photoCollectionView.indexPathsForVisibleItems.first else {
                return
            }
            self?.viewModel.downloadButtonDidTap(with: indexPath)
        }
    }
}
