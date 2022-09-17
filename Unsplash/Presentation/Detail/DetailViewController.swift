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
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(touchExitButton(_:)), for: .touchUpInside)
        return button
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
    
    private var photos: [Photo]
    private var currentIndexPath: IndexPath
    private let imageSaver: ImageSaver
    
    private let imageLoader = ImageLoader()
    
    // MARK: - View LifeCycle
    
    init(photos: [Photo], indexPath: IndexPath) {
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
        
        setupViews()
        imageSaver.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
        downloadButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        setupPhotoCollectionView()
        setupExitButton()
        setupDownloadButton()
        setupActivityIndicatorView()
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
    
    private func setupExitButton() {
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 50.0),
            exitButton.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    private func setupDownloadButton() {
        view.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.widthAnchor.constraint(equalToConstant: 50.0),
            downloadButton.heightAnchor.constraint(equalToConstant: 50.0),
            downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
        ])
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50.0),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50.0),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            activityIndicatorView.bottomAnchor.constraint(equalTo: downloadButton.bottomAnchor),
        ])
    }
    
    // MARK: - Objc
    
    @objc private func touchExitButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func touchDownloadButton(_ sender: UIButton) {
        guard let index = photoCollectionView.indexPathsForVisibleItems.first?.item else {
            return
        }
        let photo = photos[index]
        
        activityIndicatorView.startAnimating()
        
        imageLoader.load(with: photo.url) { data in
            if let image = UIImage(data: data) {
                self.imageSaver.writeToPhotoAlbum(image: image)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as? DetailPhotoCollectionViewCell else {
            return .init()
        }
        
        let photo = photos[indexPath.item]
        cell.configureCell(with: photo)
        
        return cell
    }
}

// MARK: - ImageSaverDelegate

extension DetailViewController: ImageSaverDelegate {
    func saveFailure() {
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
        activityIndicatorView.stopAnimating()
    }
    
    func saveSuccess() {
        let alertController = UIAlertController(title: "Save Success", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
        activityIndicatorView.stopAnimating()
    }
}
