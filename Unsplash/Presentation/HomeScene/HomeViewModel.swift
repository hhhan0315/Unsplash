//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    weak var coordinator: HomeCoordinatorDelegate?
    
    private let photos = BehaviorRelay<[Photo]>(value: [])
    private let alertMessage = PublishRelay<String>()
    
    private var page = 0
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectItemEvent: Observable<Photo>
        let prefetchItemEvent: Observable<[IndexPath]>
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
        
        input.didSelectItemEvent
            .subscribe(onNext: { [weak self] photo in
                self?.coordinator?.presentDetail(with: photo)
            })
            .disposed(by: disposeBag)
        
        input.prefetchItemEvent
            .compactMap(\.last?.item)
            .subscribe(onNext: { [weak self] item in
                guard let photosCount = self?.photos.value.count else {
                    return
                }
                guard item == photosCount - 1 else {
                    return
                }
                self?.fetch()
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
