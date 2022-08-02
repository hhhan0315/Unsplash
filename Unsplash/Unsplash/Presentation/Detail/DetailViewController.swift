//
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - View Define
    private lazy var photoCollectionView: UICollectionView = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { (visibleItems, scrollOffset, layoutEnvironment) in
            visibleItems.forEach({ item in
                guard let photoResponse = self.photoDataSource?.itemIdentifier(for: item.indexPath) else { return }
                self.navigationItem.title = photoResponse.user.name
            })
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.addTarget(self, action: #selector(touchDownloadButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        return activityView
    }()
    
    // MARK: - Properties
    enum Section {
        case photo
    }
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoResponse>?
    private var photos: [PhotoResponse]
    private var currentIndexPath: IndexPath
    private let imageSaver: ImageSaver
    
    // MARK: - View LifeCycle
    init(photos: [PhotoResponse], indexPath: IndexPath) {
        self.photos = photos
        self.currentIndexPath = indexPath
        self.imageSaver = ImageSaver()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        imageSaver.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
        downloadButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    private func setViews() {
        configureUI()
        configurePhotoDataSource()
    }
    
    private func configureUI() {
        view.addSubview(photoCollectionView)
        view.addSubview(downloadButton)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            downloadButton.widthAnchor.constraint(equalToConstant: 50.0),
            downloadButton.heightAnchor.constraint(equalToConstant: 50.0),
            downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
        ])
    }
    
    private func configurePhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoResponse>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoResponse in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as? DetailPhotoCollectionViewCell else {
                return DetailPhotoCollectionViewCell()
            }
            cell.configureCell(with: photoResponse)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoResponse>()
        snapshot.appendSections([Section.photo])
        snapshot.appendItems(self.photos)
        self.photoDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Objc
    @objc private func touchDownloadButton(_ sender: UIButton) {
        guard let index = photoCollectionView.indexPathsForVisibleItems.first?.item else {
            return
        }
        let photo = photoDataSource?.snapshot().itemIdentifiers[index]
        guard let urlString = photo?.urls.small else {
            return
        }
        
        ImageLoader.shared.load(urlString) { data in
            if let image = UIImage(data: data) {
                self.imageSaver.writeToPhotoAlbum(image: image)
            }
        }
    }
}

// MARK: - ImageSaverDelegate
extension DetailViewController: ImageSaverDelegate {
    func saveError() {
        let alertController = UIAlertController(title: "Photo Library Access Denied", message: "Allow Photos access in Settings to save photos to your Photo Library", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        present(alertController, animated: true)
    }
}
