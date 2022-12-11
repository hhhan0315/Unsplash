//
//  TopicPhotoListViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit
import Combine

final class TopicPhotoListViewController: UIViewController {
    
    // MARK: - View Define
    
    private let photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel = TopicPhotoListViewModel(topicPhotoRepository: DefaultTopicPhotoRepository(networkService: NetworkService()))
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private enum Section {
        case photos
    }
    
    private let topic: Topic
    
    // MARK: - View LifeCycle
    
    init(topic: Topic) {
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = topic.title
        
        photoCollectionView.dataSource = dataSource
        photoCollectionView.delegate = self
        
        setupViews()
        setupPhotoDataSource()
        bindViewModel()
        
        viewModel.viewDidLoad(with: topic.slug)
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPinterestLayout()
        setupPhotoCollectionView()
    }
    
    private func setupPinterestLayout() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        
        photoCollectionView.collectionViewLayout = pinterestLayout
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
    
    private func setupPhotoDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
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
                if photos.isEmpty {
                    self?.photoCollectionView.setContentOffset(.zero, animated: false)
                }
                
                self?.applySnapshot(with: photos)
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

extension TopicPhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 1 {
            viewModel.willDisplayLast()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath)
    }
}

// MARK: - PinterestLayoutDelegate

extension TopicPhotoListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth = UIScreen.main.bounds.width / 2
        let imageHeight = viewModel.photos[indexPath.item].height
        let imageWidth = viewModel.photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItemsInCollectionView() -> Int {
        return dataSource?.snapshot().numberOfItems ?? 0
    }
}
