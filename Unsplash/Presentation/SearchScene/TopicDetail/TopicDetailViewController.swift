//
//  TopicDetailViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TopicDetailViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let topic: Topic
    private let viewModel: TopicDetailViewModel
    private var disposeBag = DisposeBag()
        
    // MARK: - View LifeCycle
    
    init(topic: Topic, viewModel: TopicDetailViewModel) {
        self.topic = topic
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = topic.title
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = TopicDetailViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            didSelectItemEvent: photoCollectionView.rx.modelSelected(Photo.self).asObservable(),
            prefetchItemEvent: photoCollectionView.rx.prefetchItems.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.photos
            .observe(on: MainScheduler.instance)
            .bind(to: photoCollectionView.rx.items(cellIdentifier: PhotoCollectionViewCell.identifier, cellType: PhotoCollectionViewCell.self)) { index, photo, cell in
                cell.configureCell(with: photo)
            }
            .disposed(by: disposeBag)
        
        output.alertMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alertMessage in
                self?.showAlert(message: alertMessage)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PinterestLayoutDelegate

extension TopicDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight = viewModel.photo(at: indexPath.item).height
        let imageWidth = viewModel.photo(at: indexPath.item).width
        let imageRatio = imageHeight / imageWidth

        return imageRatio * cellWidth
    }
}
