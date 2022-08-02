//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    // MARK: - View Define
    private let topicCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HomeTopicCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopicCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.register(HomePhotoCollectionViewCell.self, forCellWithReuseIdentifier: HomePhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout(numberOfColumns: 1)
        layout.delegate = self
        return layout
    }()
    
    // MARK: - Properties
    enum Section {
        case topic
        case photo
    }
    
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoResponse>?
    
    private let viewModel: HomeViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - View LifeCycle
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDataSources()
        setupBind()
        viewModel.fetch()
    }
    
    // MARK: - Layout
    private func setupViews() {
        setupNavigation()
        addSubviews()
        makeConstraints()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Unsplash"
        navigationItem.backButtonTitle = ""
    }
    
    private func addSubviews() {
        view.addSubview(topicCollectionView)
        view.addSubview(photoCollectionView)
    }
    
    private func makeConstraints() {
        topicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topicCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topicCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topicCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topicCollectionView.heightAnchor.constraint(equalToConstant: 60.0),
            
            photoCollectionView.topAnchor.constraint(equalTo: topicCollectionView.bottomAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: topicCollectionView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: topicCollectionView.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - DataSource
    private func setupDataSources() {
        setupTopicDataSource()
        setupPhotoDataSource()
    }
    
    private func setupTopicDataSource() {
        topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopicCollectionViewCell.identifier, for: indexPath) as? HomeTopicCollectionViewCell else {
                return HomeTopicCollectionViewCell()
            }
            
            cell.configureCell(with: topic)
            cell.delegate = self
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([Section.topic])
        snapShot.appendItems(Topic.allCases)
        self.topicDataSource?.apply(snapShot)
    }
    
    private func setupPhotoDataSource() {
        photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoResponse>(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, photoResponse in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhotoCollectionViewCell.identifier, for: indexPath) as? HomePhotoCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(with: photoResponse)
            return cell
        })
    }
    
    // MARK: - Bind
    private func setupBind() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoResponse>()
                snapShot.appendSections([Section.photo])
                snapShot.appendItems(photos)
                self.pinterestLayout.update(numberOfItems: snapShot.numberOfItems)
                self.photoDataSource?.apply(snapShot, animatingDifferences: false)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photosCount() - 1 {
            viewModel.fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = photoDataSource?.snapshot().itemIdentifiers else {
            return
        }
        let detailViewController = DetailViewController(photos: photos, indexPath: indexPath)
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - PinterestLayoutDelegate
extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width
        let imageHeight: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(viewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
}

// MARK: - HomeTopicCollectionViewCellDelegate
extension HomeViewController: HomeTopicCollectionViewCellDelegate {
    func touchTopicButton(title: String) {
        guard let topic = Topic(rawValue: title.lowercased()) else {
            return
        }
        viewModel.update(with: topic)
    }
}
