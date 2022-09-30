//
//  TopicDetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit

final class TopicDetailViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    enum Section {
        case photos
    }
    
    private let viewModel: TopicDetailViewModel
    private let titleText: String
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoCellViewModel>?
    
    // MARK: - View LifeCycle
    
    init(slug: String, title: String) {
        self.titleText = title
        self.viewModel = TopicDetailViewModel(slug: slug)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
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
        navigationItem.title = titleText
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
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoCellViewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            cell.photoCellViewModel = photoCellViewModel
            return cell
        })
    }
    
    // MARK: - Bind
    
    private func setupViewModel() {
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoCellViewModel>()
                snapShot.appendSections([Section.photos])
                snapShot.appendItems(self?.viewModel.cellViewModels ?? [])
                self?.photoDataSource?.apply(snapShot)
            }
        }
        
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let alertMessage = self?.viewModel.alertMessage else {
                    return
                }
                self?.showAlert(title: alertMessage)
            }
        }
        
        viewModel.fetch()
    }
}

// MARK: - UICollectionViewDelegate

extension TopicDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.numberOfCells - 1 {
            viewModel.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
        let detailViewController = DetailViewController(photoCellViewModel: photoCellViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        present(detailViewController, animated: true)
    }
}

// MARK: - PinterestLayoutDelegate

extension TopicDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageHeight)
        let imageWidth = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageWidth)
        let imageRatio = imageHeight / imageWidth

        return CGFloat(imageRatio) * cellWidth
    }
    
    func numberOfItems() -> Int {
        return photoDataSource?.snapshot().numberOfItems ?? 0
    }
}
