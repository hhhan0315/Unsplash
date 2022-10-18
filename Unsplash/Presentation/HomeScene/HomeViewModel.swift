//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    weak var coordinater: HomeCoordinatorDelegate?
    
    private let photos = BehaviorRelay<[Photo]>(value: [])
    private let alertMessage = PublishRelay<String>()
    
    private var page = 0
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let willDisplayCellEvent: Observable<(cell: UICollectionViewCell, at: IndexPath)>
        let didSelectItemEvent: Observable<IndexPath>
    }
    
    struct Output {
        let photos: Observable<[Photo]>
        let alertMessage: Observable<String>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] _ in
                self?.fetch()
            })
            .disposed(by: disposeBag)
        
        input.willDisplayCellEvent
            .subscribe(onNext: { [weak self] (_, indexPath) in
                guard let photosCount = self?.photos.value.count else {
                    return
                }
                if indexPath.item == photosCount - 1 {
                    self?.fetch()
                }
            })
            .disposed(by: disposeBag)
        
        input.didSelectItemEvent
            .subscribe(onNext: { [weak self] indexPath in
                guard let photo = self?.photos.value[indexPath.item] else {
                    return
                }
                self?.coordinater?.presentDetail(with: photo)
            })
            .disposed(by: disposeBag)
        
        return Output(
            photos: photos.asObservable(),
            alertMessage: alertMessage.asObservable()
        )
    }
    
    private func fetch() {
        self.page += 1
        
        apiService.request(api: .getPhotos(page: page), dataType: [Photo].self) { [weak self] result in
            switch result {
            case .success(let photos):
                let oldPhotos = self?.photos.value ?? []
                self?.photos.accept(oldPhotos + photos)
            case .failure(let apiError):
                self?.alertMessage.accept(apiError.errorDescription)
            }
        }
    }
    
    func photo(at index: Int) -> Photo {
        return photos.value[index]
    }
}
