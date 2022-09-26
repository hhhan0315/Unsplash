
//  DetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/03.
//

import UIKit
import Combine

protocol DetailViewControllerDelegate: AnyObject {
    func scrollTo(indexPath: IndexPath?)
}

final class DetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            guard let index = visibleItems.last?.indexPath.item else {
                return
            }
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.viewModel.photo(at: index).user
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(touchDownloadButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        return activityView
    }()
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModel
    private var cancellable = Set<AnyCancellable>()
    private var currentIndexPath: IndexPath
    
    weak var delegate: DetailViewControllerDelegate?
    
    private let imageSaver = ImageSaver()
    private let imageLoader = ImageLoader()
    
    // MARK: - View LifeCycle
    
    init(viewModel: HomeViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
        imageSaver.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let currentIndexPath = photoCollectionView.indexPathsForVisibleItems.first
        delegate?.scrollTo(indexPath: currentIndexPath)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoCollectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        downloadButton.layer.cornerRadius = downloadButton.frame.width / 2
        downloadButton.clipsToBounds = true
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
        setupDownloadButton()
        setupActivityIndicatorView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = viewModel.photo(at: currentIndexPath.item).user
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
    
    private func setupBind() {
//        viewModel.$range
//            .receive(on: DispatchQueue.main)
//            .sink { range in
//                guard let range = range else {
//                    return
//                }
//                let indexPaths = range.map { IndexPath(item: $0, section: 0) }
//                self.photoCollectionView.insertItems(at: indexPaths)
//                self.photoCollectionView.reloadData()
//                self.photoCollectionView.reloadSections(IndexSet(integer: 0))
//            }
//            .store(in: &cancellable)
        
//        viewModel.$error
//            .receive(on: DispatchQueue.main)
//            .sink { apiError in
//                guard let apiError = apiError else {
//                    return
//                }
//                self.showAlert(message: apiError.errorDescription)
//            }
//            .store(in: &cancellable)
    }
    
    // MARK: - Objc
    
    @objc private func touchExitButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func touchDownloadButton(_ sender: UIButton) {
        guard let index = photoCollectionView.indexPathsForVisibleItems.first?.item else {
            return
        }
        let photo = viewModel.photo(at: index)
        
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
        return viewModel.photosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotoCollectionViewCell.identifier, for: indexPath) as? DetailPhotoCollectionViewCell else {
            return .init()
        }
        
        let photo = viewModel.photo(at: indexPath.item)
        cell.configureCell(with: photo)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
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
        showAlert(title: "저장 성공")
        activityIndicatorView.stopAnimating()
    }
}
