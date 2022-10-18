//
//  HomeViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    // MARK: - View Define
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    
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
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupPhotoCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Unsplash"
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            willDisplayCellEvent: photoCollectionView.rx.willDisplayCell.asObservable(),
            didSelectCellEvent: photoCollectionView.rx.itemSelected.asObservable()
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
            .subscribe { [weak self] alertTitle in
                self?.showAlert(title: alertTitle)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate

//extension HomeViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        coordinator?.presentDetail(with: viewModel.photo(at: indexPath.item))
//        let photoCellViewModel = viewModel.getCellViewModel(indexPath: indexPath)
//        let detailViewController = DetailViewController(photoCellViewModel: photoCellViewModel)
//        detailViewController.modalPresentationStyle = .overFullScreen
//        present(detailViewController, animated: true)
//    }
//}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.width
        let imageHeight = viewModel.photo(at: indexPath.item).height
        let imageWidth = viewModel.photo(at: indexPath.item).width
        let imageRatio = imageHeight / imageWidth

        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}