//
//  HeartViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HeartViewController: UIViewController {
    
    // MARK: - UI Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
    
    private let viewModel: HeartViewModel
    private var disposeBag = DisposeBag()
        
    // MARK: - View LifeCycle
    
    init(viewModel: HeartViewModel) {
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
        setupNotificationCenter()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
        setupTextLabel()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Likes"
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTextLabel() {
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
        
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = HeartViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            didSelectItemEvent: photoCollectionView.rx.modelSelected(Photo.self).asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.photos
            .observe(on: MainScheduler.instance)
            .bind(to: photoCollectionView.rx.items(cellIdentifier: PhotoCollectionViewCell.identifier, cellType: PhotoCollectionViewCell.self)) { index, photo, cell in
                cell.configureCell(with: photo)
            }
            .disposed(by: disposeBag)
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

// MARK: - UICollectionViewDelegateFlowLayout

extension HeartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let imageHeight = viewModel.photo(at: indexPath.item).height
        let imageWidth = viewModel.photo(at: indexPath.item).width
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
