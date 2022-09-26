//
//  PinterestDetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit
import Combine

final class PinterestDetailViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel: PinterestDetailViewModel
    private let titleString: String
    
    private var cancellable = Set<AnyCancellable>()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    enum Section {
        case photos
    }
    
    // MARK: - View LifeCycle
    
    init(slug: String, title: String) {
        self.viewModel = PinterestDetailViewModel(slug: slug)
        self.titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBind()
        
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
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = titleString
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
    
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                return .init()
            }
            cell.configureCell(with: photo)
            return cell
        })
    }
    
    // MARK: - Bind
    
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(photos)
                self.photoDataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { apiError in
                guard let apiError = apiError else {
                    return
                }
                self.showAlert(message: apiError.errorDescription)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate

extension PinterestDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(photo: viewModel.photo(at: indexPath.item))
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - PinterestLayoutDelegate

extension PinterestDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth

        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItems() -> Int {
        return photoDataSource?.snapshot().numberOfItems ?? 0
    }
}
