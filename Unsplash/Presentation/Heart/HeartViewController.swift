//
//  HeartViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit
import Combine

final class HeartViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel = HeartViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    enum Section {
        case photos
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
        setupPhotoDataSource()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Likes"
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.configureCellWithFileManager(with: photo)
            return cell
        })
    }
        
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(photos)
                self?.photoDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.showAlert(message: error.localizedDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate

extension HeartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photo: viewModel.photo(at: indexPath.item))
        detailViewController.modalPresentationStyle = .fullScreen
        present(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HeartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let imageHeight = CGFloat(viewModel.photo(at: indexPath.row).height)
        let imageWidth = CGFloat(viewModel.photo(at: indexPath.row).width)
        let imageRatio = imageHeight / imageWidth

        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
