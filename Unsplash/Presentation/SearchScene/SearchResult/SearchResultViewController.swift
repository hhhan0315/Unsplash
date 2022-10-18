//
//  SearchResultViewController.swift
//  Unsplash
//
//  Created by rae on 2022/09/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchResultViewController: UIViewController {
    
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
    
    private let viewModel = SearchResultViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        setupPhotoCollectionView()
    }
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let input = SearchResultViewModel.Input(
            willDisplayCellEvent: photoCollectionView.rx.willDisplayCell.asObservable(),
            didSelectItemEvent: photoCollectionView.rx.modelSelected(Photo.self).asObservable()
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

extension SearchResultViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageHeight = viewModel.photo(at: indexPath.item).height
        let imageWidth = viewModel.photo(at: indexPath.item).width
        let imageRatio = imageHeight / imageWidth

        return imageRatio * cellWidth
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        photoCollectionView.setContentOffset(.zero, animated: false)
        viewModel.update(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.reset()
    }
}
