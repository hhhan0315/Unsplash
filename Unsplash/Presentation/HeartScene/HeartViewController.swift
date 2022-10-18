//
//  HeartViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit

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
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "No photos"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    enum Section {
        case photos
    }
    
    private let viewModel = HeartViewModel()
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoCellViewModel>?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupViewModel()
        setupNotificationCenter()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
        setupTextLabel()
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
    
    private func setupTextLabel() {
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoCellViewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
//            cell.photoCellViewModel = photoCellViewModel
            return cell
        })
    }
        
    // MARK: - Bind
    
    private func setupViewModel() {
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.textLabel.isHidden = self?.viewModel.cellViewModels.isEmpty == true ? false : true
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
                self?.showAlert(message: alertMessage)
            }
        }
        
        viewModel.fetch()
    }
    
    // MARK: - NotificationCenter
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetch), name: Notification.Name.heartButtonClicked, object: nil)
    }
    
    // MARK: - Objc
    
    @objc private func fetch() {
        viewModel.fetch()
    }
}

// MARK: - UICollectionViewDelegate

extension HeartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
//        let detailViewController = DetailViewController(photoCellViewModel: photoCellViewModel)
//        detailViewController.modalPresentationStyle = .overFullScreen
//        present(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HeartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let imageHeight = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageHeight)
        let imageWidth = CGFloat(viewModel.getCellViewModel(indexPath: indexPath).imageWidth)
        let imageRatio = imageHeight / imageWidth

        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
